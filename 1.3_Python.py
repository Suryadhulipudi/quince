#Write a python script to read all *.txt files from a directory. Assume there are nested directories
import os

def read_txt_files(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".txt"):
                file_path = os.path.join(root, file)
                with open(file_path, 'r') as txt_file:
                    content = txt_file.read()
                    print(f"Contents of {file_path}:\n{content}")

# Replace 'your_directory_path' with the actual path of the directory you want to explore
directory_path = 'your_directory_path'

# Call the function with the specified directory
read_txt_files(directory_path)
