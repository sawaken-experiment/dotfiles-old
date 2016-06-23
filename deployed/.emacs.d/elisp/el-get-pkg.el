; ----------------------------------------------------------------------
; auto-complete
; ----------------------------------------------------------------------

(el-get-bundle auto-complete)

; ----------------------------------------------------------------------
; Color-Theme-Solarized
; ----------------------------------------------------------------------

;(el-get-bundle color-theme-solarized)

;(load-theme 'solarized t)
;(set-terminal-parameter nil 'background-mode 'dark)
;(set-frame-parameter nil 'background-mode 'dark)
;(enable-theme 'solarized)

; ----------------------------------------------------------------------
; Atom-One-Dark-Theme
; ----------------------------------------------------------------------

(el-get-bundle jonathanchu/atom-one-dark-theme)

(add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/atom-one-dark-theme/")
(load-theme 'atom-one-dark t)

; ----------------------------------------------------------------------
; Tabbar
; ----------------------------------------------------------------------

(el-get-bundle tabbar)

(require 'tabbar)
(tabbar-mode)

(global-set-key (kbd "<C-tab>") 'tabbar-forward-tab)
(global-set-key (kbd "<C-S-tab>") 'tabbar-backward-tab)

;;----- 左側のボタンを消す
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))

(set-face-attribute
'tabbar-default nil
:family "MeiryoKe_Gothic"
:background "#34495E"
:foreground "#EEEEEE"
:height 0.95
)
(set-face-attribute
'tabbar-unselected nil
:background "#34495E"
:foreground "#EEEEEE"
:box nil
)
(set-face-attribute
'tabbar-modified nil
:background "#E67E22"
:foreground "#EEEEEE"
:box nil
)
(set-face-attribute
'tabbar-selected nil
:background "#E74C3C"
:foreground "#EEEEEE"
:box nil)
(set-face-attribute
'tabbar-button nil
:box nil)
(set-face-attribute
'tabbar-separator nil
:height 2.0)

;; タブに表示させるバッファの設定
(defvar my-tabbar-displayed-buffers
 '("*scratch*" "*Messages*" "*Backtrace*" "*Colors*" "*Faces*" "*vc-")
 "*Regexps matches buffer names always included tabs.")

(defun my-tabbar-buffer-list ()
 "Return the list of buffers to show in tabs.
Exclude buffers whose name starts with a space or an asterisk.
The current buffer and buffers matches `my-tabbar-displayed-buffers'
are always included."
 (let* ((hides (list ?\  ?\*))
        (re (regexp-opt my-tabbar-displayed-buffers))
        (cur-buf (current-buffer))
        (tabs (delq nil
                    (mapcar (lambda (buf)
                              (let ((name (buffer-name buf)))
                                (when (or (string-match re name)
                                          (not (memq (aref name 0) hides)))
                                  buf)))
                            (buffer-list)))))
   ;; Always include the current buffer.
   (if (memq cur-buf tabs)
       tabs
     (cons cur-buf tabs))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)

; ----------------------------------------------------------------------
; editorconfig
; ----------------------------------------------------------------------

(el-get-bundle editorconfig)

(require 'editorconfig)
(editorconfig-mode 1)
