import argparse
import os

import h5py
import imageio
import numpy as np

parser = argparse.ArgumentParser(description='Script that convert a .h5 depthmap to .pfm file in tmp folder')
parser.add_argument( '--file_path', type=str, required=True, help='path to the h5py file')
args = parser.parse_args()

file_name = ''.join(os.path.basename(args.file_path).split('.')[:-1])
# print('file_name', file_name)

output_path = os.path.join('/tmp', f'{file_name}.pfm')
''' read the original depth '''
with h5py.File(args.file_path, "r") as hdf5_file:
    depth = np.array(hdf5_file["/depth"])
depth[depth==0] = float('nan')
''' save the depth as .pfm file '''
imageio.imwrite(output_path, np.flipud(depth))
