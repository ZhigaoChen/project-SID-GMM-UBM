import os

__author__ = 'zhangxulong'


def change_sampling_rate_160k(parent, audio_wav):
    print parent

    output_dir = 'out/' + parent
    output = 'out/' + audio_wav
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    cmd_line = "ffmpeg -i " + audio_wav + " -ar 16k -y " + output
    os.system(cmd_line)

    return 0


def batch_change_sampling_rate_160k(dir):
    for parent, dirname, filename in os.walk(dir):
        for file in filename:
            path = os.path.join(parent, file)
            change_sampling_rate_160k(parent, path)
    return 0


print "test..."
batch_change_sampling_rate_160k('data')
