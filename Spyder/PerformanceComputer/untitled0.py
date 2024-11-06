# -*- coding: utf-8 -*-
"""
Created on Mon Feb 26 16:53:57 2024

@author: NGUYEN MANH DUNG
"""

from pytube import YouTube
link ="https://www.youtube.com/watch?v=KiNLTJh8oZE"
yt = YouTube(link)
yt.stream.first().download()