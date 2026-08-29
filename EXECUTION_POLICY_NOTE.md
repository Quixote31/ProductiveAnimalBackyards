# Execution Policy Note

The BAT launchers use:

`PowerShell -ExecutionPolicy Bypass`

This applies **only to the PowerShell process started by the BAT file**.

It does **not** permanently change the user's Windows PowerShell execution
policy and does **not** disable Windows Defender or other antivirus software.

This is required on systems where PowerShell script execution is disabled by
default.

The PowerShell source remains included in plain text for review.
