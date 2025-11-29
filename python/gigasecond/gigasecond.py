"""
A script to calculate my gigasecond birthday.
"""

from datetime import datetime
from zoneinfo import ZoneInfo

# The Montevideo timezone.
mvd: ZoneInfo = ZoneInfo("America/Montevideo")

# The instant I was born.
birth: datetime = datetime(1994, 11, 28, 12, 30, 0, tzinfo=mvd)

# The instant I was born in UTC.
birth_utc: datetime = birth.astimezone(ZoneInfo("UTC"))

# Add a gigasecond.
gs: int = 1_000_000_000
gs_utc: datetime = datetime.fromtimestamp(
    birth_utc.timestamp() + gs, tz=ZoneInfo("UTC")
)
print(f"Gigasecond anniversary (UTC):    {gs_utc}")

# Print in Sydney time.
syd: ZoneInfo = ZoneInfo("Australia/Sydney")
gs_syd: datetime = gs_utc.astimezone(syd)
print(f"Gigasecond anniversary (Sydney): {gs_syd}")
