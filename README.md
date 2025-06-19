# hackedincolorado

This repository collects assorted logs, reports, and notes from the 2025 investigation. Most files are artifacts captured from various devices.

## Logso Reporter

A simple logger-like helper is provided in `logso_reporter.py`. It prints timestamped messages and can trigger a canary file when an unexpected `mark` value is used.

### Example usage

```python
from logso_reporter import send_event_logso

send_event_logso("info", "demo start")
send_event_logso("error", "something odd", {"mark": "iam.n0t.you.4304"})
```

Running the module directly also demonstrates a few calls for testing.
