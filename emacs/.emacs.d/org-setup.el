;; open notes using f2
(global-set-key (kbd "<f2>") (lambda () (interactive) (find-file "~/OneDrive/notes/notes.org")))
(setq org-agenda-files (list "~/OneDrive/notes/notes.org"))
