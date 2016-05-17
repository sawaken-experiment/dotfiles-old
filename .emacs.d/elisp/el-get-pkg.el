; ----------------------------------------------------------------------
; auto-complete
; ----------------------------------------------------------------------

(el-get-bundle auto-complete)

; ----------------------------------------------------------------------
; Color-Theme-Solarized
; ----------------------------------------------------------------------

(el-get-bundle color-theme-solarized)

(load-theme 'solarized t)
(set-terminal-parameter nil 'background-mode 'dark)
(set-frame-parameter nil 'background-mode 'dark)
(enable-theme 'solarized)
