#karaoke gen
import googlesearch
import requests


def get_lyrics(artist:str, song:str, album:str):
    #try to get lyrics by google search
    searchStr = artist +' '+ song
    search = googlesearch.search(searchStr)
    for j in search:
        if 'genius.com' in j:
            cleanup = ['\\','\"tag\"','\"data\"','\"href\"','{:\"\', \'\"}','{\"children\":[']
            r = requests(j) 
            r = r[r.content.find('lyricsData'):]
            r = r[:r.find('root')]
            r = r.replace('<br>', 'br\\')
            r = r.split('br\\')
            print(r)
    return lyrics

def run_uvr(inputFile):
    #run ultimate vocal remover on file
    return

def sync_lyrics(vocalFile,lyrics):
    #try to generate lyric timings from lyrics and vocalFile
    return


if __name__ == '__main__':
    get_lyrics('nakey jakey', 'south dakota', '')

    #],\\"tag\\":\\"p\\"},\\"\\"],\\"tag\\":\\"root\\"},\\"lyricsPlaceholderReason\\":null,\\"clientTime