# `Sarasa Term TC Nerd` 字型

## 關於

`Sarasa Term TC Nerd` 字型是以 [Sarasa Term
TC](https://github.com/be5invis/Sarasa-Gothic)字型為基礎，修改了[Nerd
fonts](https://github.com/ryanoasis/nerd-fonts)字型補丁程式，然後用該程式將`Nerd
fonts`合併入`Sarasa Term TC`, 再經過一些後處理，而最後形成的字型。該字型特別適合
**繁體中文**使用者在**終端**或者**程式碼編輯器**中使用。

上游版本：

- Sarasa Term TC：1.0.37
- Nerd Font：3.4.0
- Font Patcher：3.4.0

## 字型效果

- 文字效果：以 Regular 樣式為例

  ![文字效果](screenshots/character.png)
- 圖示效果：Starship 圖示

  ![圖示效果](screenshots/nerd.jpg)
- 對齊效果：終端裡 emacs/org-mode 中的表格對齊

  ![對齊效果](screenshots/align.png)

## 特性

- `Sarasa Term TC` 是極少數做到中文和英文 2:1 嚴格對齊的字型，特別適合用來寫代
  碼, 以及中英文混合的字元式表格的對齊等。而且該字型字重全面，共包含十個：
  ExtraLight, ExtraLightItalic, Light, LightItalic, Regular, Italic, SemiBold,
  SemiBoldItalic, ExtraBold, ExtraBoldItalic.
- `Nerd fonts` 提供了很多圖示字型，特別適合各種
  Shell(zsh/bash...)/Vim/NeoVim/Emacs/lsd/eza...的主題， 例如
  [`Powerline`](https://github.com/powerline/powerline)，
  [`Starship`](https://github.com/starship/starship)
- 對一些符號進行了縱向拉伸，不會出現`Powerline`條帶中高低不一，無法上下對齊的情
  況。
- 原始`Sarasa Term TC`字型和`Sarasa Term TC Nerd`字型可以共存，不會產生衝突。
- 將 `OS/2` 表中的 `xAvgCharWidth` 屬性進行了設定，避免了在 windows 系統下，一些
  不支援新版本 `OS/2` 表的軟體中字距不正常的問題。
- 加入了`hdmx`表，解決了 windows 系統下的一些情況下無法嚴格對齊的問題。
- 修正了`OS/2`表中的`panose`和`post`表中的`isFixedPitch`，使得字型被系統認出是等
  寬字型。
- 在龐大的 `material design` 圖示庫中，只跳躍選擇一部分圖示，以避免`65534`的字元
  數硬頂。

## 安裝

- MacOS 使用者可以直接透過 cask 安裝：
  ```sh
  brew tap laishulu/homebrew
  brew install font-sarasa-nerd
  ```
- 手工下載安裝：
  - 前往 [release](https://github.com/laishulu/Sarasa-Term-TC-Nerd/releases) 下載
  - 每個`ttf`檔案是一個字型樣式，`ttc`檔案是所有樣式的合集。
  
**注意**:
如果本字型在你的系統中渲染得慢，你需要下載安裝無字形微調（`Unhinted`）版本的字型。

## 使用

在你的主題配置檔案中，使用 `Sarasa Term TC Nerd`。

## 自己生成字型

```sh
# Install deps
sudo apt update && sudo apt install -y fontforge python3-fontforge p7zip-full jq aria2

# Init submodules and build
git submodule update --init --recursive
bash -xeu build-fonts.sh
```

`nerd-fonts` 是已套用本專案修改的 submodule；建置流程會直接使用
`nerd-fonts/font-patcher`，不再於主專案保留或套用額外 patch 檔。`7zr` 會以
`-mmt=on` 建立 `.7z` 壓縮檔。

可用 `JOBS` 平行處理字重：

```sh
JOBS=$(nproc) bash -xeu build-fonts.sh
```

`fontTools` 由 uv 專案相依安裝；`fontforge` Python binding 目前不是 PyPI/uv 套件，仍需由 FontForge 安裝提供。

在 macOS 中，注意需要使用 fontforge 自帶的 python；可用 `UV_PYTHON` 指定該 Python。

```sh
brew install fontforge
UV_PYTHON=/Applications/FontForge.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 bash -xeu build-fonts.sh
```

在合併`material design`圖示時需要注意：
- 雖然實際上`65535`是硬頂，但是`65535`在字型處理的很多地方被作為魔法數，所以用
  `65534`作為硬頂。
- 同一個字型，不同字型樣式的圖示數不同，斜體比常規體要多。為了避免硬頂，應當根據
  斜體圖示的數量來計算。
