#!/usr/bin/env python

from datetime import datetime, timedelta
import sys
from pathlib import Path


def run_app() -> None:
    """
    Main controller.
    """
    try:
        reminder_file = open(f'{Path.home()}/.reminders.rem', 'a')
    except FileNotFoundError:
        raise

    match sys.argv[1]:
        case 'timer':
            time, out, sub = set_timer().values()

        case 'point':
            time, out, sub = set_reminder().values()

        case _:
            raise TypeError

    reminder_file.write(f'REM {time} MSG {sub}\n')

    print(out)


def set_timer() -> dict:
    """
    Set reminder with time from now.
    """
    try:
        subject = input('Subject: ')
        hours = input('Hours: ')
        minutes = input('Minutes: ')
    except KeyboardInterrupt:
        raise

    time = datetime.now() + timedelta(hours=int(hours), minutes=int(minutes))

    return {
        'time': time.strftime('%b %d %Y AT %H:%M'),
        'output': f'Timer set for {subject} in {hours} hours and {minutes} minutes.',
        'subject': subject,
    }


def set_reminder() -> dict:
    """
    Set reminder for fixed date.
    """
    try:
        subject = input('Subject: ')
        on = input('Date: ')
        at = input('Time: ')
    except KeyboardInterrupt:
        raise

    time = datetime.strptime(f'{on} {at}', '%Y-%m-%d %H:%M')

    return {
        'time': time.strftime('%b %d %Y AT %H:%M'),
        'output': f'Reminder set for {subject} on {time}',
        'subject': subject,
    }


if __name__ == '__main__':
    try:
        run_app()
    except KeyboardInterrupt:
        quit('\nAborted')
    except FileNotFoundError:
        quit('No reminders file! Put reminders.rem into ~/.config/reminder/')
    except TypeError:
        quit('Unknown mode!\nAvailable modes are: "timer" & "point"')
