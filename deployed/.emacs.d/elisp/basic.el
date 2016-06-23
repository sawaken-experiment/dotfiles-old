; ----------------------------------------------------------------------
; 文字コード
; ----------------------------------------------------------------------

(set-language-environment "Japanese")
(let ((ws window-system))
  (cond ((eq ws 'w32)
         (prefer-coding-system 'utf-8-unix)
         (set-default-coding-systems 'utf-8-unix)
         (setq file-name-coding-system 'sjis)
         (setq locale-coding-system 'utf-8))
        ((eq ws 'ns)
         (require 'ucs-normalize)
         (prefer-coding-system 'utf-8-hfs)
         (setq file-name-coding-system 'utf-8-hfs)
         (setq locale-coding-system 'utf-8-hfs))))

; ----------------------------------------------------------------------
; フォント設定
; ----------------------------------------------------------------------

; 拡大/縮小時に無効になってしまうのでボツ
;(set-default-font "-*-Osaka-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")

; 効かないっぽい
;(defconst FONT_SIZE 30)

(defconst FONT_FAMILY "Ricty")
(set-face-attribute 'default (selected-frame) :height 180)

; ----------------------------------------------------------------------
; 表示に関する色々
; ----------------------------------------------------------------------

; スタートアップ非表示
(setq inhibit-startup-screen t)

; scratchの初期メッセージ消去
(setq initial-scratch-message "")

; ツールバー非表示
(tool-bar-mode -1)

; メニューバーを非表示
;;(menu-bar-mode -1)

; スクロールバー非表示
(set-scroll-bar-mode nil)

; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

; ----------------------------------------------------------------------
; 行番号表示
; ----------------------------------------------------------------------

(global-linum-mode t)

;テーマ側で設定されるので不要
;(set-face-attribute 'linum nil
;                    :foreground "#800"
;                    :height 160)

; 行番号フォーマット
(setq linum-format "%4d")

; 拡大/縮小時に行番号カラムのサイズも適切に変更する
; https://www.emacswiki.org/emacs/LineNumbers
(defun linum-update-window-scale-fix (win)
  "fix linum for scaled text"
  (set-window-margins win
		      (ceiling (* (if (boundp 'text-scale-mode-step)
				      (expt text-scale-mode-step
					    text-scale-mode-amount) 1)
				  (if (car (window-margins))
				      (car (window-margins)) 1)
				  ))))
(advice-add #'linum-update-window :after #'linum-update-window-scale-fix)

; ----------------------------------------------------------------------
; 括弧の範囲内を強調表示
;   - 要らない気がするので中止
; ----------------------------------------------------------------------

;(show-paren-mode t)
;(setq show-paren-delay 0)
;(setq show-paren-style 'expression)

; ----------------------------------------------------------------------
; 行末の空白を強調表示
; ----------------------------------------------------------------------

(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")

; ----------------------------------------------------------------------
; タブ関連
; ----------------------------------------------------------------------

; ソフトタブにする
(setq-default indent-tabs-mode t)

; タブ幅
; よくわからないけど, どれも効かないっぽい
;(custom-set-variables '(tab-width 4))
;(setq-default tab-width 4)
;(setq default-tab-width 4)

; ----------------------------------------------------------------------
; yes or noをy or n
; ----------------------------------------------------------------------

(fset 'yes-or-no-p 'y-or-n-p)

; ----------------------------------------------------------------------
; 最近使ったファイル
; ----------------------------------------------------------------------

; 最近使ったファイルをメニューに表示
(recentf-mode t)

; 最近使ったファイルの表示数
(setq recentf-max-menu-items 10)

; 最近開いたファイルの保存数を増やす
(setq recentf-max-saved-items 3000)

; ----------------------------------------------------------------------
; ミニバッファ
; ----------------------------------------------------------------------

; ミニバッファの履歴を保存する
(savehist-mode 1)

; ミニバッファの履歴の保存数を増やす
(setq history-length 3000)

; ----------------------------------------------------------------------
; バックアップを残さない
; ----------------------------------------------------------------------

(setq make-backup-files nil)

; ----------------------------------------------------------------------
; 行間
; ----------------------------------------------------------------------

(setq-default line-spacing 0)

; ----------------------------------------------------------------------
; 1行ずつスクロール
; ----------------------------------------------------------------------

(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t) ;; shell-mode

; ----------------------------------------------------------------------
; フレームの透明度
; ----------------------------------------------------------------------

(set-frame-parameter (selected-frame) 'alpha '(1.00))

; ----------------------------------------------------------------------
; C-Ret で矩形選択
;   - 詳しいキーバインド操作：http://dev.ariel-networks.com/articles/emacs/part5/
; ----------------------------------------------------------------------

(cua-mode t)
(setq cua-enable-cua-keys nil)

; ----------------------------------------------------------------------
; 設定ファイル専用のメジャーモードを使えるようにする:
;   - よくわからないが, dotfileを編集するときに色が付くっぽい.
; ----------------------------------------------------------------------

(require 'generic-x)

; ----------------------------------------------------------------------
; モードライン
; ----------------------------------------------------------------------

;; モードラインに行番号表示
(line-number-mode t)

;; モードラインに列番号表示
(column-number-mode t)

;; 総行数を表示するようにする.
(defvar my-lines-page-mode t)
(defvar my-mode-line-format)

(when my-lines-page-mode
  (setq my-mode-line-format "%d")
  (if size-indication-mode
      (setq my-mode-line-format (concat my-mode-line-format " of %%I")))
  (cond ((and (eq line-number-mode t) (eq column-number-mode t))
         (setq my-mode-line-format (concat my-mode-line-format " (%%l,%%c)")))
        ((eq line-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " L%%l")))
        ((eq column-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " C%%c"))))

  (setq mode-line-position
        '(:eval (format my-mode-line-format
                        (count-lines (point-max) (point-min))))))
