import os
import sys

appname = 'subsync'


if getattr(sys, 'frozen', False) and hasattr(sys, '_MEIPASS'):
    datadir = '/config/subsync_datadir/'
else:
    datadir = '/config/subsync/'


if sys.platform == 'win32':
    configdir = os.path.join(os.environ['APPDATA'], appname)
    shareddir = os.path.join(os.environ['ALLUSERSPROFILE'], appname)
    assetupd  = 'subsync/win-x86_64'

elif sys.platform == 'linux':
    configdir = '/config/subsync_linux/'
    shareddir = configdir
    assetupd =  None

elif sys.platform == 'darwin':
    configdir = '/config/subsync_darwin/'
    shareddir = configdir
    assetupd = 'subsync/mac-x86_64'

else:
    configdir = '/config/subsync_else/'
    shareddir = configdir
    assetupd  = None

configpath = '/config/subsync/subsync.json'
assetspath = '/config/subsync/assets/'

assetdir   = os.path.join(shareddir, 'assets')
imgdir     = os.path.join(datadir, 'img')
localedir  = os.path.join(datadir, 'locale')
keypath    = os.path.join(datadir, 'key.pub')

assetsurl = 'https://github.com/sc0ty/subsync/releases/download/assets/assets.json'
