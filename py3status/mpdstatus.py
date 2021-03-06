#!/usr/bin/env python

"""mpdstatus py3status module.

mpdstatus is a MPD module for py3status.
It shows the currently playing song and can be used to pause, resume or stop
playpack.

Copyright (C) 2013 Tablet Mode <tablet-mode AT monochromatic DOT cc>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see [http://www.gnu.org/licenses/].

"""

from time import time

from mpd import MPDClient, CommandError


class MPDstatusException(Exception):

    """Custom mpdstatus exception."""

    def __init__(self, exception):
        """Initialisation."""
        self.exception = exception

    def __str__(self):
        """Prepend message with 'mpdstatus: '."""
        return "mpdstatus: {exception}".format(exception=self.exception)


class Data:

    """Aquire data."""

    def __init__(self, host, port, password):
        """Initialise MPD client."""
        self.count = 0
        self.HOST = host
        self.PORT = port
        self.PW = password
        self.client = MPDClient()
        self._connect()

    def _crop_text(self, text, length=32):
        """Crop string to specified length."""
        if len(text) > length:
            text = "{}...".format(text[:length])

        return text

    def _connect(self):
        """Connect to MPD."""
        try:
            self.client.connect(self.HOST, self.PORT)
            if self.PW:
                self.client.password(self.PW)
        except CommandError as e:
            if "incorrect password" in str(e).lower():
                raise MPDstatusException("incorrect password")
        except ConnectionRefusedError:
            # This is handled elsewhere by displaying the text `not connected`
            # in the status bar.
            pass

    def disconnect(self):
        """Close connection to MPD cleanly."""
        try:
            self.client.close()
            self.client.disconnect()
        except:
            # If this happens, the client is most likely already disconnected
            # anyway.
            pass

    def reconnect(self):
        """Try to reaquire MPD connection."""
        self.disconnect()
        self._connect()

    def has_connection(self):
        """Check if MPD is reachable."""
        try:
            self.client.status()
        except:
            return False
        else:
            return True

    def previous(self):
        """Jump to previous song."""
        self.client.previous()

    def next(self):
        """Go to next song."""
        self.client.next()

    def pause(self):
        """Pause playback."""
        self.client.pause()

    def wrap_tag(self, song, tag):
        if (tag in song):
            return song[tag]
        else:
            return ""

    def get_stats(self, length):
        """Return artist, songtitle and playback state."""
        song = self._crop_text(self.client.currentsong())
        status = self.client.status()
        artist = self._crop_text(
            song['artist']) if 'artist' in song else "Unknown Artist"

        if (self.wrap_tag(song, 'genre') == "Classical"):
            if (self.wrap_tag(song, 'comment') != ""):
                data = "%s: %s - %s" % \
                       (self.wrap_tag(song,'composer'),
                        self.wrap_tag(song, 'comment'),
                        self.wrap_tag(song, 'title'))
            else:
                data = "%s: %s" % \
                       (self.wrap_tag(song,'composer'),
                        self.wrap_tag(song, 'title'))
        else:
            data = "%s: %s" % (artist, self.wrap_tag(song,('title')))

        return (self._crop_text(data, length=length), status['state'])


class Py3status:

    """This is where all the py3status magic happens."""

    cache_timeout = 0
    name = 'MPD:'
    host = 'localhost'
    port = 6600
    password = ''
    length = 40

    def __init__(self):
        """Initialisation."""
        self.data = None

    def kill(self, json, i3status_config, event):
        """Handle termination."""
        self.data.disconnect()

    def on_click(self, json, i3status_config, event):
        """Handle mouse clicks."""
        # Middle click: Go to previous song
        if event['button'] == 2:
            self.data.previous()
        # Left click: Pause playback
        elif event['button'] == 1:
            self.data.pause()
        # Right click: Jump to next song
        elif event['button'] == 3:
            self.data.next()

    def mpdstatus(self, json, i3status_config):
        """Return response for i3status bar."""
        response = {'full_text': '', 'name': 'mpdstatus'}

        # Initialise Data class only once
        # TODO: parse settings in separate function for better error handling
        if not self.data:
            self.data = Data(self.host, self.port, self.password)

        connection = self.data.has_connection()

        if connection:
            data, state = self.data.get_stats(self.length)

            if state == 'play':
                response['color'] = i3status_config['color_good']
            elif state == 'pause':
                response['color'] = i3status_config['color_degraded']

            response['full_text'] = data
        else:
            self.data.reconnect()
            response['color'] = i3status_config['color_bad']
            response['full_text'] = "%s not connected" % (self.name)

        response['cached_until'] = time() + self.cache_timeout

        return response


if __name__ == "__main__":
    from time import sleep
    x = Py3status()
    while True:
        print(x.mpdstatus([], {}))
        sleep(5)
