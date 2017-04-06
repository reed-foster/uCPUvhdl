# draw.py
This simple python application runs a GUI that allows the user to draw black and white bitmaps and copy-paste the vhdl code for a static array

both draw.py and xbmarray_remapper.py must be in the same directory for the application to work

File>Import allows you to choose a .xbm file or the native .obm (.obm is basically the same, just without header information for dimensions; if importing a .xbm, make sure that the dimensions are 128wide by 64high-I'll probably add support for different size displays in the future)

File>Overwrite overwrites .obm data to the current file

File>Export to... allows the user to select a file to export data to

File>Exit exits the application

Copy Bitmap Data will copy the data in the bitmap text field to the clipboard (so if it is changed manually, then the .obm/.xbm file will include those changes)
