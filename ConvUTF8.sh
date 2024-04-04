#! /bin/csh -f
#  Irino T.
#  Created: 13 Oct20
#  Modified: 18 Jun 21
# 
#
# 最初のバージョンだとリンク先を指定すること
#
# ln -s   /Volumes/WDB6Toct20a/Pictures/写真_Library.photoslibrary Photo_Source
# ln -s   /Volumes/TO4Toct20/写真_Library.photoslibrary_bak Photo_Backup
#
#
#!/bin/csh -f
#  Irino T.
#  Created:  4 Apr 24
# 
#
# conversion to UTF 8 
#
cd /Users/irino/GitHub_Public/
mkdir DemoAuditoryFilter_U8

cd DemoAuditoryFilter


foreach f (*.m)

echo $f
echo "nkf -w8 $f > ../DemoAuditoryFilter_U8/$f"
nkf -w8 $f >  ../DemoAuditoryFilter_U8/$f
end

