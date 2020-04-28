import pandas as pd
from matplotlib import pyplot as plt


def import_csv(filename):
    data = pd.read_csv(filename, sep=',', header=0)
    if len(data.columns) < 2:
        data = pd.read_csv(filename, sep=';', header=0)
    return data


def plot_multi_col(data):
    lgd = []
    for col in data.columns[1:]:
        plt.plot(data[data.columns[0]], data[col])
        lgd.append(col)
    plt.xlabel(data.columns[0])
    plt.legend(lgd)


def calc_throughput(time, bytes_send):
    dtime = []
    _dt = 0
    throughput = []
    last = 0
    for i, _t in enumerate(time):
        if _t >= _dt:
            dtime.append(_dt)
            throughput.append(bytes_send[i] - last)
            last = bytes_send[i]
            _dt += 1
    return (dtime, throughput)


def calc_est_throughput(cwnd, rtt):
    _rtt = []
    for r in rtt:
        _rtt.append(r) if r != 0 else _rtt.append(0.01)
    return [3/4 * c/r for (c, r) in zip(cwnd, _rtt)]


def plot_out_csv(data):
    """Uncomment everything you want to have on a plot
    """
    columns = ['time',
               'cwnd1',
               'cwnd2',
               'cwnd3',
               'rtt1',
               'rtt2',
               'rtt3',
               'bytes1',
               'bytes2',
               'bytes3']
    lgd = []
    #  plt.plot(data[columns[0]], data[columns[1]])  # cwnd1
    #  lgd.append(columns[1])
    #  plt.plot(data[columns[0]], data[columns[2]])  # cwnd2
    #  lgd.append(columns[2])
    #  plt.plot(data[columns[0]], data[columns[3]])  # cwnd3
    #  lgd.append(columns[3])
    #  plt.plot(data[columns[0]], data[columns[4]])  # rtt1
    #  lgd.append(columns[4])
    #  plt.plot(data[columns[0]], data[columns[5]])  # rtt2
    #  lgd.append(columns[5])
    #  plt.plot(data[columns[0]], data[columns[6]])  # rtt3
    #  lgd.append(columns[6])
    #  plt.plot(data[columns[0]], data[columns[7]])  # bytes1
    #  lgd.append(columns[7])
    #  plt.plot(data[columns[0]], data[columns[8]])  # bytes2
    #  lgd.append(columns[8])
    #  plt.plot(data[columns[0]], data[columns[9]])  # bytes3
    #  lgd.append(columns[9])

    #  dtime, throughput1 = calc_throughput(data[columns[0]], data[columns[7]])
    #  plt.plot(dtime, throughput1)
    #  lgd.append('throughput1')
    #  dtime, throughput2 = calc_throughput(data[columns[0]], data[columns[8]])
    #  plt.plot(dtime, throughput2)
    #  lgd.append('throughput2')
    #  dtime, throughput3 = calc_throughput(data[columns[0]], data[columns[9]])
    #  plt.plot(dtime, throughput3)
    #  lgd.append('throughput3')

    # est_throughput1 = calc_est_throughput(data[columns[1]], data[columns[4]])
    # plt.plot(data[columns[0]], est_throughput1)
    # lgd.append('estimated_throughput1')
    # est_throughput2 = calc_est_throughput(data[columns[2]], data[columns[5]])
    # plt.plot(data[columns[0]], est_throughput2)
    # lgd.append('estimated_throughput2')
    # est_throughput3 = calc_est_throughput(data[columns[3]], data[columns[6]])
    # plt.plot(data[columns[0]], est_throughput3)
    # lgd.append('estimated_throughput3')

    plt.legend(lgd)
    plt.xlabel(columns[0])
    filename = ''
    for l in lgd:
        filename += f'_{l}'
    return filename


if __name__ == "__main__":
    #  plot_multi_col(import_csv('out/zad1/zad1_avg_spd.csv'))
    #  filename = 'zad1_avg_spd'
    #  plt.savefig(f'{filename}.pdf')
    #  plt.savefig(f'{filename}.png')
    #  plt.clf()

    #  f_suffix = plot_out_csv(import_csv('out/zad1/zad1_100.csv'))
    #  filename = f'zad1{f_suffix}'
    #  plt.savefig(f'{filename}.pdf')
    #  plt.savefig(f'{filename}.png')
    #  plt.clf()

    #  plot_multi_col(import_csv('out/zad2/zad2_avg_spd.csv'))
    #  filename = 'zad2_avg_spd'
    #  plt.savefig(f'{filename}.pdf')
    #  plt.savefig(f'{filename}.png')
    #  plt.clf()

    #  f_suffix = plot_out_csv(import_csv('out/zad2/zad2_5.csv'))

    #  f_suffix = plot_out_csv(import_csv('out/zad2/zad2_130.csv'))
    #  plt.legend(['buf_size=5', 'buf_size=130'])
    #  filename = f'zad2_5_130{f_suffix}'
    #  plt.savefig(f'{filename}.pdf')
    #  plt.savefig(f'{filename}.png')
    #  plt.clf()

    #  plot_multi_col(import_csv('out/zad3/zad3_avg_spd.csv'))
    #  filename = 'zad3_avg_spd'
    #  plt.savefig(f'{filename}.pdf')
    #  plt.savefig(f'{filename}.png')
    #  plt.clf()

    #  f_suffix = plot_out_csv(import_csv('out/zad4/zad4_5.csv'))
    #  filename = f'zad4_5{f_suffix}'
    #  plt.savefig(f'{filename}.pdf')
    #  plt.savefig(f'{filename}.png')
    #  plt.clf()

    #  f_suffix = plot_out_csv(import_csv('out/zad4/zad4_200.csv'))
    #  filename = f'zad4_200{f_suffix}'
    #  plt.savefig(f'{filename}.pdf')
    #  plt.savefig(f'{filename}.png')
    #  plt.clf()
    pass  # put plot commands here
