general_sync() {
    local port=$1
    local user=$2
    local source=$3
    local destination=$4
    shift 4  # Remove the first four arguments (port, user, source, destination)

    # Ensure the source ends with a trailing slash
    if [[ "$source" != */ ]]; then
        source="$source/"
    fi

    # Determine the remote host
    local remote_host=""
    if [[ "$source" == *:* ]]; then
        # Source is remote
        remote_host=$(echo "$source" | cut -d':' -f1)
    elif [[ "$destination" == *:* ]]; then
        # Destination is remote
        remote_host=$(echo "$destination" | cut -d':' -f1)
    fi

    # Define the ControlPath for SSH multiplexing
    local control_path="/tmp/ssh_control_${user}@%h:%p"

    # Start a master connection for SSH multiplexing if a remote host is found
    if [[ -n "$remote_host" ]]; then
        ssh -p "$port" -o ControlMaster=auto -o ControlPath="$control_path" -o ControlPersist=10m "$remote_host" true
    fi

    # Perform a dry-run with stats and human-readable sizes
    echo -e "\033[1;34mPerforming a dry-run to estimate data transfer...\033[0m"
    rsync_output=$(rsync -e "ssh -p $port -o ControlPath=$control_path" -az --dry-run --stats --human-readable --out-format="%n" "$@" \
        --rsync-path="mkdir -p $(dirname "$destination") && rsync" \
        "$source" "$destination")

    # Extract the total transferred file size from the rsync output
    local total_size=$(echo "$rsync_output" | grep -oP "Total transferred file size:.*" | cut -d':' -f2 | xargs)
    local file_list=$(echo "$rsync_output" | grep -v "Total transferred file size:" | grep -v "Number of files:")

    # Display the transferred file list
    echo -e "\n\033[1;33mFiles to be transferred:\033[0m"
    echo -e "\033[0;32m$file_list\033[0m"

    # Display the total transferred file size in bold and color
    echo -e "\n\033[1;35mTotal transferred file size: \033[1;32m$total_size\033[0m"

    # Ask for confirmation with default as 'yes'
    echo -e "\033[1;34mDry-run completed. Do you want to proceed with the actual transfer? (Y/n)\033[0m"
    read -r confirmation
    confirmation=${confirmation:-y}  # Default to 'y' if no input

    if [[ "$confirmation" != [Yy]* ]]; then
        echo -e "\033[1;31mTransfer aborted by user.\033[0m"
        # Close the master connection if a remote host was used
        if [[ -n "$remote_host" ]]; then
            ssh -p "$port" -o ControlPath="$control_path" -O exit "$remote_host"
        fi
        return
    fi

    # Perform the actual transfer
    echo -e "\033[1;34mStarting the actual transfer...\033[0m"
    rsync -e "ssh -p $port -o ControlPath=$control_path" -az --info=progress2 --human-readable "$@" \
        --rsync-path="mkdir -p $(dirname "$destination") && rsync" \
        "$source" "$destination"

    # Close the master connection if a remote host was used
    if [[ -n "$remote_host" ]]; then
        ssh -p "$port" -o ControlPath="$control_path" -O exit "$remote_host"
    fi

    echo -e "\033[1;32mTransfer completed successfully!\033[0m"
}

