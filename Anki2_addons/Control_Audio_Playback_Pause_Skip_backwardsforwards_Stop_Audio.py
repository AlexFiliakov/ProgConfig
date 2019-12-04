import anki.sound
from anki.hooks import wrap
from aqt.reviewer import Reviewer
def my_keyHandler(self, evt):
    key = unicode(evt.text())
    if key == "5":
        anki.sound.mplayerManager.mplayer.stdin.write("pause\n")
    if key == "6":
        anki.sound.mplayerManager.mplayer.stdin.write("seek -5 0\n")
    if key == "7":
        anki.sound.mplayerManager.mplayer.stdin.write("seek 5 0\n")
    if key == "8":
        anki.sound.mplayerManager.mplayer.stdin.write("stop\n")
    if key == "n":
        anki.sound.mplayerManager.mplayer.stdin.write("pause\n")
    if key == "N":
        anki.sound.mplayerManager.mplayer.stdin.write("pause\n")
    if key == "m":
        anki.sound.mplayerManager.mplayer.stdin.write("stop\n")
Reviewer._keyHandler = wrap(Reviewer._keyHandler, my_keyHandler)
