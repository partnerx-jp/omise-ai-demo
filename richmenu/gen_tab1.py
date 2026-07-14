from PIL import Image, ImageDraw, ImageFont
import sys

import os
OUT = sys.argv[1] if len(sys.argv)>1 else os.path.join(os.path.dirname(os.path.abspath(__file__)),"tab1.png")
W, H = 2500, 1686
HEADER = 300
GREEN = (29, 180, 70)
INK = (34, 34, 34)
SUB = (150, 150, 150)
LINE = (236, 236, 236)
HSUB = (223, 244, 231)

W6 = "/System/Library/Fonts/ヒラギノ角ゴシック W6.ttc"
W3 = "/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc"
def f(p, s): return ImageFont.truetype(p, s, index=0)

img = Image.new("RGB", (W, H), "white")
d = ImageDraw.Draw(img)

# header
d.rectangle([0, 0, W, HEADER], fill=GREEN)
d.text((W/2, 110), "お店AI ― タップして体験", font=f(W6, 96), fill="white", anchor="mm")
d.text((W/2, 214), "多店舗バックオフィスを、届くだけに。", font=f(W3, 42), fill=HSUB, anchor="mm")

# grid 4x2
cols, rows = 4, 2
tw = W / cols
th = (H - HEADER) / rows
tiles = [
    ("売上実績", "毎朝7時に届く"), ("PL速報", "翌月1日に自動"), ("請求書登録", "写真で経理完了"), ("入金情報登録", "入金を自動で消込"),
    ("売上照合チェック", "レジ締めを突合"), ("翌日シフト通知", "前夜に自動配信"), ("シフト回収", "希望を自動集計"), ("口コミ通知", "新着を即通知"),
]
tf = f(W6, 66)
sf = f(W3, 34)
for i, (title, subt) in enumerate(tiles):
    c, r = i % cols, i // cols
    x0, y0 = c*tw, HEADER + r*th
    cx = x0 + tw/2
    dot_y, rad = y0 + 150, 15
    d.ellipse([cx-rad, dot_y-rad, cx+rad, dot_y+rad], fill=GREEN)
    d.text((cx, y0 + 258), title, font=tf, fill=INK, anchor="mm")
    d.text((cx, y0 + 350), subt, font=sf, fill=SUB, anchor="mm")

# borders
for c in range(1, cols):
    d.line([(c*tw, HEADER), (c*tw, H)], fill=LINE, width=2)
d.line([(0, HEADER + th), (W, HEADER + th)], fill=LINE, width=2)

img.save(OUT)
print("saved", OUT)
