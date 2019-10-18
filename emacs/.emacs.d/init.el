(require 'package)
(setq package-enable-at-startup nil)
;; Setup package repositories
(setq package-archives (append package-archives
			       '(("gnu" . "https://elpa.gnu.org/packages/")
				 ("marmalade" . "https://marmalade-repo.org/packages/")
				 ("melpa" . "https://melpa.org/packages/"))))
(package-initialize)

;; See http://cachestocaches.com/2015/8/getting-started-use-package/ and https://github.com/gjstein/emacs.d/blob/master/init.el

;; Bootstrap "use-package"
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Enable use-package
(eval-when-compile
  (require 'use-package))
(require 'bind-key)                ;; if you use any :bind variant

;; reload .emacs config using f1 and open config using shift+f1
(global-set-key (kbd "<f1>") (lambda () (interactive) (load-file "~/.emacs.d/init.el")))
(global-set-key (kbd "S-<f1>") (lambda () (interactive) (find-file "~/.emacs.d/init.el")))

;; open inbox using f2
(global-set-key (kbd "<f2>") (lambda () (interactive) (find-file "~/repos/notes/Inbox.org")))
(global-set-key (kbd "<f3>") (lambda () (interactive) (find-file "~/repos/masterarbeit/notes/Masterarbeit.org")))

;; smali mode https://github.com/strazzere/Emacs-Smali
(add-to-list 'load-path "~/.emacs.d/includes")
; load the smali/baksmali mode
(autoload 'smali-mode "smali-mode" "Major mode for editing and viewing smali issues" t)
(add-to-list 'auto-mode-alist '(".smali$" . smali-mode))

;; TODO do better
;; setup tools which are
(require 'openwith)
(openwith-mode t)
(setq openwith-associations '(("\\.pdf\\'" "qpdfviewunique" (file))))

;; (require 'ergoemacs-mode)
;; (setq ergoemacs-theme nil) ;; Uses Standard Ergoemacs keyboard theme
;; (setq ergoemacs-keyboard-layout "de") ;; Assumes QWERTY keyboard layout
;; (ergoemacs-mode 1)

(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
	(exchange-point-and-mark))
    (let ((column (current-column))
	  (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (beginning-of-line)
    (when (or (> arg 0) (not (bobp)))
      (forward-line)
      (when (or (< arg 0) (not (eobp)))
	(transpose-lines arg))
      (forward-line -1)))))

(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(global-set-key (kbd "C-<up>") 'move-text-up)
(global-set-key (kbd "C-<down>") 'move-text-down)
(global-set-key (kbd "C-S-d") 'duplicate-current-line-or-region)

; Navigate in Windows
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)

(global-set-key (kbd "C-#") 'comment-line)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-<delete>") 'kill-whole-line)
(global-set-key (kbd "C-l") 'linum-mode)
(global-set-key (kbd "C-S-g") 'goto-line)
(global-set-key (kbd "C-<") 'shrink-window-horizontally)
(global-set-key (kbd "C->") 'enlarge-window-horizontally)
(global-set-key (kbd "C->") 'enlarge-window-horizontally)
(global-set-key (kbd "C-M-l") 'downcase-region)
(global-set-key (kbd "C-M-u") 'upcase-region)
(global-set-key (kbd "C-M-f") 'forward-sexp)  ;; goto matching paranthesis forwards
(global-set-key (kbd "C-M-b") 'backward-sexp) ;; goto matching paranthesis backwards

(define-key isearch-mode-map (kbd "<f3>") 'isearch-repeat-forward)
(define-key isearch-mode-map (kbd "S-<f3>") 'isearch-repeat-backward)

;; https://www.emacswiki.org/emacs/DeletingWhitespace
 (add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun open-terminal()
  (interactive)
  (ansi-term "/bin/zsh"))

(global-set-key (kbd "M-0") 'open-terminal)

(use-package undo-tree
  :ensure t
  :bind (("C-S-z" . undo-tree-redo)
	 ("C-y" . undo-tree-redo)
	 ("C-z" . undo-tree-undo))
  :config
  (global-undo-tree-mode))

;; Multiple Cursor stuff
;; https://emacs.stackexchange.com/questions/39129/multiple-cursors-and-return-key
(use-package multiple-cursors
  :ensure t
  :bind (("C-d" . mc/mark-next-like-this)
	 ("C-M-d" . mc/mark-previous-like-this)
	 ("C-M-<down>" . 'mc/mark-next-lines)
	 ("C-M-<up>" . 'mc/mark-previous-lines)
	 (:map mc/keymap ("<escape>" . 'mc/keyboard-quit))
	 ("<return>" . nil)))

(use-package magit
  :ensure t)

;; (use-package ledger-mode
  ;; :ensure t)

;; keebindings see: https://github.com/sabof/project-explorer
(use-package project-explorer
  :ensure t
  :bind (("C-<tab>" . project-explorer-toggle)))

(use-package helm
  :ensure t
  :bind (("C-x p" . helm-apropos)
	 ("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-buffers-list)))

(use-package projectile
  :ensure t
  :bind (("C-S-f" . projectile-grep)))

;; fancy searching package
(use-package swiper
  :ensure t
  :bind (("C-f" . swiper)))

(use-package helm-projectile
  :ensure t
  :bind (("C-t" . helm-projectile)))

;; confiture org mode
(use-package org
  :ensure t
  :bind (("C-c l" . 'org-store-link)
	 ("C-c <down>" . 'org-shiftdown)
	 ("C-c <up>" . 'org-shiftup)
	 ("C-c <left>" . 'org-shiftleft)
	 ("C-c <right>" . 'org-shiftright)
	 ("S-<f11>" . 'org-todo-list-current-file)
	 ("<f11>" . 'org-todo-list)
	 ("S-<f12>" . 'org-agenda-list-current-file)
	 ("<f12>" . 'org-agenda-list)
	 ("C-c a" . 'org-agenda))
  :config
  (setq org-log-done t)
  ;; undefince C-<tab> so project-explorer will toggle, see https://stackoverflow.com/questions/4333467/override-ctrl-tab-in-emacs-org-mode
  (define-key org-mode-map [(control tab)] nil)
  (setq org-export-initial-scope 'subtree)
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
		 '("notes"
		   "\\documentclass{article}
		    \\usepackage[margin=0.5in]{geometry}
		    \\usepackage[parfill]{parskip}
		    \\usepackage[utf8]{inputenc}
		    \\usepackage{amsmath,amssymb,amsfonts,amsthm}
        	    \\usepackage{hyperref}
	            \\renewcommand\\maketitle{}
	            \\renewcommand\\tableofcontents{}
                    \\renewcommand{\\arraystretch}{1.5}
                    [NO-DEFAULT-PACKAGES]"))))

;; TODO remove redundant code
(defun org-todo-list-current-file (&optional arg)
  "Like `org-todo-list', but using only the current buffer's file."
  (interactive "P")
  (let ((org-agenda-files (list (buffer-file-name (current-buffer)))))
    (if (null (car org-agenda-files))
        (error "%s is not visiting a file" (buffer-name (current-buffer)))
      (org-todo-list arg))))

(defun org-agenda-list-current-file (&optional arg)
  "Like `org-todo-list', but using only the current buffer's file."
  (interactive "P")
  (let ((org-agenda-files (list (buffer-file-name (current-buffer)))))
    (if (null (car org-agenda-files))
        (error "%s is not visiting a file" (buffer-name (current-buffer)))
      (org-agenda-list arg))))

;; undefine inconvenient org mode shortcuts
(dolist (key '("S-<right>" "S-<left>" "S-<up>" "S-<down>" "C-S-<right>"
	       "C-S-<left>" "C-S-<up>" "C-S-<down>"))
  (define-key org-mode-map (kbd key) nil))

;; (use-package tex :ensure auctex)
;; (add-hook 'LaTeX-mode-hook #'turn-on-flyspell)

(use-package auto-complete
  :ensure t)

;; (use-package auto-complete-auctex
;;  :ensure t)

;; fancy python mode
;; requires:
;; sudo apt-get install python-pip
;; sudo pip install jedi flake8 importmagic autopep8
;; TODO maybe automatically install when installing emacs package
(use-package elpy
  :ensure t
  :config
  (elpy-enable))

;; lua language support
(use-package lua-mode
  :ensure t)

;; Some setup for c-mode
;; see http://wikemacs.org/wiki/C-ide
;; https://tuhdo.github.io/c-ide.html
;; requires:
;; sudo apt-get install global
(use-package helm-gtags
  :ensure t)

(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

(use-package git-gutter
  :ensure t
  :config (global-git-gutter-mode +1))

;; TODO use package properly
;; (use-package highlight-indent-guides
;;   :ensure t)
;; (setq highlight-indent-guides-method 'character)
;; (highlight-indent-guides-mode)

;; Klammern werden automatisch geschlossen
(electric-pair-mode)
(show-paren-mode)

;; mode for using ctrl-c, ctrl-v, ...
(cua-mode t)

;; always follow symlinks when opening files
(setq vc-follow-symlinks t)

;; Do not wrap long lines!
(set-default 'truncate-lines t)
(setq truncate-partial-width-windows nil)

(global-auto-complete-mode t)

;; Meldung beim start von emacs kommt nicht mehr
(setq inhibit-startup-message t)

;; disable indention
;; (defun indent-according-to-mode nil)

;; emacs indentiert nie mit tabs anstatt spaces
(setq tab-always-indent nil)

;; setup compile command to call make in the directory of the closest makefile
;; see https://www.emacswiki.org/emacs/CompileCommand
(require 'cl)
(defun* get-closest-pathname (&optional (file "Makefile"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
    (expand-file-name file
		      (loop
			for d = default-directory then (expand-file-name ".." d)
			if (file-exists-p (expand-file-name file d))
			return d
			if (equal d root)
			return nil))))

;; (set (make-local-variable 'compile-command) (format "make -C %s" (file-name-directory (get-closest-pathname))))
(defun compile ()
  "Speichert das Dokument und kompiliert dann"
  (interactive)
  (save-buffer)
  (start-process "compile-process" "compile-output" "make" "-C" (file-name-directory (get-closest-pathname))))
(global-set-key (kbd "<f5>") 'compile)

; Disable annoying beeping
(setq ring-bell-function 'ignore)

;; Syntax highlighting in org code blocks
(setq org-src-fontify-natively t)
;; Org mode zeigt Einrückungen an
(setq org-startup-indented t)
;; Kann parent nicht auf done setzen wenn Kind noch nicht erledigt
(setq org-enforce-todo-dependencies t)


;; Keine backupdateien überall neben datei legen
(setq backup-directory-alist (quote (("." . "~/.emacs.d/backups"))))

;; Woche beginnt am Montag
(setq calendar-week-start-day 1)

;; Refresht automatisch Dateien, die sich auf Disk geändert haben, aber
;;   in Emacs nicht verändert wurden. Kann immer mit Undo rückgängig
(setq global-auto-revert-mode t)

; startet den server, dass emacsclient funktioniert
(load "server")
(server-force-delete)
(server-start)

;; Interessant:
;;    * https://github.com/sebastiencs/sidebar.el

;; TODO:
;;   * Multiple-Cursors + Cua-mode
;;   * Split to seperate files
;;   * shift-left/up/rigth/down für org-mode umbelgen sodass shift ... vernünftig verwendet werden kann
;;   * C-IDE
;;   * Python-IDE

;; ENDE init.el
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(ledger-reports
   (quote
    (("test" "ledger ")
     ("bal" "%(binary) -f %(ledger-file) bal")
     ("reg" "%(binary) -f %(ledger-file) reg")
     ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
     ("account" "%(binary) -f %(ledger-file) reg %(account)"))))
 '(org-agenda-files (quote ("~/repos/notes/")))
 '(package-selected-packages
   (quote
    (ledger-mode openwith lua-mode helm-gtags ggtags swiper elpy pdf-tools highlight-indent-guides git-gutter auto-complete-auctex auctex helm-projectile helm magit undo-tree use-package multiple-cursors))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
