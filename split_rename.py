from matplotlib import pylab
import numpy
import os
import wave
from pydub import AudioSegment

__author__ = 'zhangxulong'

dicts = {"aerosmith": '10001', "beatles": "10002", 'creedence_clearwater_revival': '10003', 'cure': '10004',
         'dave_matthews_band': '10005', 'depeche_mode': "10006",
         "fleetwood_mac": '10007', 'garth_brooks': '10008', "green_day": '10009', "led_zeppelin": "10010",
         'madonna': '10011',
         'metallica': '10012', 'prince': '10013', 'queen': '10014', 'radiohead': '10015', "roxette": "10016",
         'steely_dan': '10017', 'suzanne_vega': '10018', 'tori_amos': '10019', 'u2': '10020'}


def rename_artist_folds(dir='dataset'):
    for parent, dirname, filename in os.walk(dir):
        for file in filename:
            src = os.path.join(parent, file)
            artist = src.split('/')[1]
            title = src.split('/')[3]
            label = dicts[artist]
            dest = "out/" + label + "/" + title
            if not os.path.exists("out/" + label + "/"):
                os.makedirs("out/" + label + "/")
            print dest
            os.rename(src, dest)
            print src

    return 0


def conmbine(singer_item='zhangxulong', dir='out'):
    combine_songs = []
    for parent, dirname, filename in os.walk(dir):
        for file in filename:
            path = os.path.join(parent, file)

            singer_name = path.split('/')[1]
            if singer_name == singer_item:
                combine_songs.append(path)
                # print singer_name
    all_sound = AudioSegment.empty()
    for sound in combine_songs:
        all_sound += AudioSegment.from_wav(sound)
    output_dir = "artist20_combined/" + singer_item + ".wav"
    if not os.path.exists("artist20_combined/"):
        os.makedirs("artist20_combined/")
    all_sound.export(output_dir, format="wav")
    return 0


def combine_same_singer(dir="out"):
    singers = []
    for parent, dirname, filename in os.walk(dir):
        for file in filename:
            path = os.path.join(parent, file)

            singer_name = path.split('/')[1]
            print singer_name
            singers.append(singer_name)
    singers_set = set(singers)

    for singer_item in singers_set:
        conmbine(singer_item, dir)
        # print singer_item

    print singers_set
    return 0


def split_10_folds(wav='example.wav', fold=100):
    out_dir = "100_fold/"
    seconds = 1000
    file_name = os.path.basename(wav)
    files = file_name.split('.')[0]
    file_name = out_dir + files + "/"
    if not os.path.exists(out_dir + files):
        os.makedirs(out_dir + files)
    sound = AudioSegment.from_wav(wav)
    durations = sound.duration_seconds
    print durations
    print fold
    part_durations = int(durations / fold)
    print part_durations
    for part in range(fold - 1):
        print part
        part_sound = sound[(part_durations * part * seconds):(part_durations * seconds * (part + 1))]
        part_sound.export(file_name + str(part) + ".wav", format='wav')
    last_part_sound = sound[(fold - 1) * seconds * part_durations:]
    last_part_sound.export(file_name + str(fold - 1) + ".wav", format='wav')
    return 0


def batch_split_10_folds(dir='artist20_combined'):
    for parent, dirname, filename in os.walk(dir):
        for file in filename:
            path = os.path.join(parent, file)
            split_10_folds(path)
    return 0


def split_train_test(dir='100_fold'):
    # test = ['0', '1', '2', '3', '4']
    test = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    for parent, dirname, filename in os.walk(dir):
        for file in filename:
            src = os.path.join(parent, file)
            one_dir = src.split('/')[0] + '/'
            two_dir = src.split('/')[1] + '/'
            title = src.split('/')[2]
            test_dir = 'test/'
            train_dir = 'train/'
            title_no = title.split('.')[0]
            if title_no in test:
                dest = one_dir + two_dir + test_dir + title
                if not os.path.exists(one_dir + two_dir + test_dir):
                    os.makedirs(one_dir + two_dir + test_dir)
                os.rename(src, dest)
            else:
                dest = one_dir + two_dir + train_dir + title
                if not os.path.exists(one_dir + two_dir + train_dir):
                    os.makedirs(one_dir + two_dir + train_dir)
                os.rename(src, dest)

    return 0


def draw_wav(wav_dir):
    print "begin draw_wav ==feature_extraction.py=="
    song = wave.open(wav_dir, "rb")
    params = song.getparams()
    nchannels, samplewidth, framerate, nframes = params[:4]  # format info
    song_data = song.readframes(nframes)
    song.close()
    wave_data = numpy.fromstring(song_data, dtype=numpy.short)
    wave_data.shape = -1, 1
    wave_data = wave_data.T
    time = numpy.arange(0, nframes) * (1.0 / framerate)
    len_time = len(time)
    time = time[0:len_time]
    pylab.plot(time, wave_data[0])
    pylab.xlabel("time")
    pylab.ylabel("wav_data")
    pylab.show()
    return 0


# test = AudioSegment.from_wav('10_fold/10001/test/0.wav')
# print test.channels
# rename_artist_folds()
# combine_same_singer()
# batch_split_10_folds()
# split_train_test()
# draw_wav('10_fold/10001/test/0.wav')
