import time
# depend on ffmpeg it need add the untrust ppa to ubuntu
# sudo add-apt-repository ppa:mc3man/trusty-media
# sudo apt-get update
# sudo apt-get dist-upgrade
__author__ = 'zhangxulong'
# use for collect songs but here we use a dataset and this code will be the util to handle the dataset.
import os
import os.path
import numpy
import pylab
import pydub
import scipy.io.wavfile


def transform_mp3_wav(mp3_dir):
    dataset_wav = 'dataset_wav/'

    if not os.path.exists(dataset_wav):
        os.mkdir(dataset_wav)
    new_wav_dir = dataset_wav + os.path.splitext(mp3_dir)[0] + '.wav'
    new_dir = os.path.dirname(new_wav_dir)
    if not os.path.exists(new_dir):
        os.makedirs(new_dir)
    audio = pydub.AudioSegment.from_mp3(mp3_dir)
    audio.export(new_wav_dir, format="wav")
    return 0


def draw_wave(wave_data, nframes, framerate):
    time_x = numpy.arange(0, nframes) * (1.0 / framerate)
    len_time = len(time_x)
    time_x = time_x[0:len_time]
    pylab.subplot(211)
    pylab.plot(time_x, wave_data[0])
    pylab.subplot(212)
    pylab.plot(time_x, wave_data[1], c="r")
    pylab.xlabel("time")
    pylab.ylabel("wav_data")
    pylab.show()
    return 0


def transform_dataset_into_wav(dataset_dir):
    # "split your dataset's audio file into short segments and rename in new dir"
    for parent, dirnames, filenames in os.walk(dataset_dir):
        for song_names in filenames:
            song_dir = os.path.join(parent, song_names)
            transform_mp3_wav(song_dir)
    return 0


def split_into_segment(wav_dir, seconds=5):
    parent_dir = "short_wav/"

    dir_filename, extname = os.path.splitext(wav_dir)
    sample_rate, audio = scipy.io.wavfile.read(wav_dir)
    segments = len(audio) / (seconds * sample_rate)  # the last segments short than 3 second are ignored
    item = 0
    if not os.path.exists(parent_dir):
        os.mkdir(parent_dir)
    while item < segments:
        new_wav_dir = parent_dir + dir_filename + str(item) + extname
        new_dir = os.path.dirname(new_wav_dir)
        if not os.path.exists(new_dir):
            os.makedirs(new_dir)
        f = open(new_wav_dir, 'wb')
        scipy.io.wavfile.write(f, sample_rate, audio[item * seconds * sample_rate:(item + 1) * seconds * sample_rate])
        f.close()
        item += 1
    return 0


def split_dataset_into_short(dataset_dir, seconds=5):
    # "split your dataset's audio file into short segments and rename in new dir"
    for parent, dirnames, filenames in os.walk(dataset_dir):
        for song_names in filenames:
            song_dir = os.path.join(parent, song_names)
            split_into_segment(song_dir, seconds)
    return 0


def generate_file_list_to_txt_file(dataset='dataset'):
    for parent, dirnames, filenames in os.walk(dataset):
        for filename in filenames:
            song_dir = os.path.join(parent, filename)
            txt_file = open('dataset_dir_list.txt', 'a')
            txt_file.write(song_dir + '\r\n')
            txt_file.close()
    return 0


def trans_stereo_mono(wav_file):
    from pydub import AudioSegment
    audio = AudioSegment.from_wav(wav_file)
    audio_mono = audio.set_channels(1)
    new_dir = 'dataset_mono/' + wav_file
    new_dir_path = os.path.dirname(new_dir)
    if not os.path.exists(new_dir_path):
        os.makedirs(new_dir_path)
    audio_mono.export(new_dir, format='wav')
    return 0


def generate_mono_wav(dataset='dataset'):
    for parent, dirnames, filenames in os.walk(dataset):
        for filename in filenames:
            song_dir = os.path.join(parent, filename)
            trans_stereo_mono(song_dir)
    return 0


def remove_a_of_matlab_dataset(dataset_dir):
    for parent, dirnames, filenames in os.walk(dataset_dir):
        for filename in filenames:
            song_dir = os.path.join(parent, filename)
            remove_the_file(song_dir)
    return 0


def remove_the_file(file_audio):
    import os
    import re
    format_batch = re.compile('.*_A\\.wav')
    if format_batch.match(file_audio):
        os.remove(file_audio)
    return 0


def rename(dataset_dir):
    for parent, dirnames, filenames in os.walk(dataset_dir):
        for filename in filenames:
            src = os.path.join(parent, filename)
            print src
            new_file = filename.split('_')[0] + ".wav"
            print new_file
            dst = os.path.join(parent, new_file)
            print(dst)
            os.rename(src, dst)
    return 0


if __name__ == '__main__':
    # dataset_dir = 'dataset_mp3/'  # mp3 dataset
    # dataset_wav_dir = 'dataset_wav/'  # wav dataset
    # dataset_short_wav_dir = 'dataset/'  # short wav dataset
    # test_dir = 'd/'
    start = time.time()
    # transform_dataset_into_wav(dataset_dir)
    # 1.change your dataset mp3 to wav
    # generate_mono_wav(dataset_wav_dir)
    # 2.trans_to_mono_wav_dataset==========================="
    # generate_file_list_to_txt_file('dataset_mono')
    # 3.'generate list of file dir========================'
    # matlab: rpca_mask_run.m
    # 4.goto matlab and split the vocal
    # remove_a_of_matlab_dataset('dataset_matlab')
    # 5.remove the A and just keep the E vocal one of the matlab dataset
    # split_dataset_into_short('dataset_E_vocal',5)
    # 6.split to 5 seconds short wav
    time.sleep(1)
    # generate_file_list_to_txt_file('/home/mirlab/zhangxulong/code/MatlabProjects/singing-voice-separation-rpca/example/107singersMp3_20_fold/')
    # remove_a_of_matlab_dataset('/home/mirlab/zhangxulong/code/MatlabProjects/singing-voice-separation-rpca/example/output/107singersMp3_20_fold_16k/')
    rename(
        '/home/mirlab/zhangxulong/code/MatlabProjects/singing-voice-separation-rpca/example/output/107singersMp3_20_fold_16k/')
    # generate_file_list_to_txt_file('/home/mirlab/zhangxulong/code/MatlabProjects/singing-voice-separation-rpca/example/107singersMp3_20_fold_16k/')
    finish = time.time()
    total_time = round(finish - start)
    print "run it takes time:%.5f (seconds)" % total_time
