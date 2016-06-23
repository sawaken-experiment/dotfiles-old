; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; --------------------------------------------------
;; Emacsの設定:
;;  - Emacs24以上を想定.
;;  - 主な参考サイト:
;;    - http://d.hatena.ne.jp/sandai/20120304/p2
;;  - 外部拡張は全てEl-Getに任せる.
;;  - .emacs.d/elisp/は独自設定ファイルを分割保存するために使う.
;; --------------------------------------------------

;; ------------------------------------------------------------------------
;; .emacs.d/elisp/をロードパスに追加

;; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; load-pathに追加するフォルダ
;; 2つ以上フォルダを指定する場合の引数 => (add-to-load-path "elisp" "xxx" "xxx")
(add-to-load-path "elisp")

;; ------------------------------------------------------------------------
;; El-Get

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))


;; ------------------------------------------------------------------------
;; 設定

(load "basic")
(load "keybind")
(load "el-get-pkg")
