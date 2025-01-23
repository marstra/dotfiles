;; Set the directory for org-agenda files
(setq org-agenda-files '("~/repos/pers/notes/org"))
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 2))))
(setq org-default-notes-file "~/repos/pers/notes/org/inbox.org")

(setq org-capture-templates
      '(("s" "Schedule task to inbox" entry
         (file+headline "~/repos/pers/notes/org/inbox.org" "Inbox")
         "* TODO [#3] %?\12SCHEDULED: %T" :jump-to-captured nil)))

(setq org-global-properties
      '(("Effort_ALL" . "0:05 0:10 0:15 0:30 0:45 1:00 1:30 2:00 3:00 4:00 5:00 6:00 7:00")))
(setq org-columns-default-format
      "%40ITEM(Task) %17Effort(Estimated Effort){:} %10CLOCKSUM_T(Time Spent)")

(setq org-capture-use-agenda-date t)
(setq org-agenda-show-future-repeats nil)

(require 'org)
(require 'org-clock)

;; usage: emacsclient -e "(my/print-active-clock)"
(defun my/print-active-clock ()
  ;; Call org-clock-get-clock-string without properties for use in xbar/Kargos
  (if (org-clock-is-active)
      (princ (org-no-properties (org-clock-get-clock-string)))))
