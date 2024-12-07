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

    # Define the ControlPath for SSH multiplexing
    local control_path="/tmp/ssh_control_${user}@%h:%p"

    # Start a master connection for SSH multiplexing
    ssh -p "$port" -o ControlMaster=auto -o ControlPath="$control_path" -o ControlPersist=10m "$user@localhost" true

    # Perform a dry-run with stats and human-readable sizes
    echo "Performing a dry-run to estimate data transfer..."
    rsync -e "ssh -p $port -o ControlPath=$control_path" -az --dry-run --stats --human-readable "$@" \
        --rsync-path="mkdir -p $(dirname "$destination") && rsync" \
        "$source" "$destination"
    
    # Ask for confirmation with default as 'yes'
    echo "Dry-run completed. Do you want to proceed with the actual transfer? (Y/n)"
    read -r confirmation
    confirmation=${confirmation:-y}  # Default to 'y' if no input

    if [[ "$confirmation" != [Yy]* ]]; then
        echo "Transfer aborted by user."
        # Close the master connection
        ssh -p "$port" -o ControlPath="$control_path" -O exit "$user@localhost"
        return
    fi

    # Perform the actual transfer
    echo "Starting the actual transfer..."
    rsync -e "ssh -p $port -o ControlPath=$control_path" -az --info=progress2 --human-readable "$@" \
        --rsync-path="mkdir -p $(dirname "$destination") && rsync" \
        "$source" "$destination"

    # Close the master connection
    ssh -p "$port" -o ControlPath="$control_path" -O exit "$user@localhost"
}

