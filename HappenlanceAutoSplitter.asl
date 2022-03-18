// SPDX-FileCopyrightText: © 2021 Phillip Trudeau-Tavara <pmttavara@protonmail.com>
// SPDX-License-Identifier: 0BSD

// Happenlance AutoSplitter v1.02a
// Works for Happenlance v1.02a and into the future (until I break it).
// You can try to write one for the older versions but, best of luck tbh.
// Basically public domain (zero-clause BSD license). License at bottom of file.

state("Happenlance", "1.02a") {
    ulong ticks : 0x0;
    ulong level : 0x0;
    ulong checkpoint : 0x0;
    ulong killed_final_boss : 0x0;
}
state("Happenlance", "1.01e") {
    ulong ticks : 0x0;
    ulong level : 0x0;
    ulong checkpoint : 0x0;
    ulong killed_final_boss : 0x0;
}
startup {
    settings.Add("split_on_level", true, "Split On Level");
    settings.Add("split_on_checkpoint", false, "Split On Checkpoint");
    settings.Add("split_on_killed_final_boss", true, "Split On Killing Final Boss");
}
init { version = modules.First().FileVersionInfo.FileVersion; }
update {
    if (version == "1.0") return false;
    if (version == "1.0.1") return false;
    if (version == "1.0.1a") return false;
    if (version == "1.0.1b") return false;
    if (version == "1.01a") return false;
    if (version == "1.01b") return false;
    if (version == "1.01c") return false;
    if (version == "1.01d") return false;
    current.ticks = memory.ReadValue<ulong>(new IntPtr(0xb00b50000));
    current.level = memory.ReadValue<ulong>(new IntPtr(0xb00b50008));
    current.checkpoint = memory.ReadValue<ulong>(new IntPtr(0xb00b50010));
    current.killed_final_boss = memory.ReadValue<ulong>(new IntPtr(0xb00b50018));
}
gameTime { return TimeSpan.FromSeconds(current.ticks / 180.0); }
isLoading { return true; }
start { return current.ticks > old.ticks; }
reset { return current.ticks < old.ticks; }
split {
    if (settings["split_on_level"] && current.level != 0xffffffff && current.level != old.level) return true;
    if (settings["split_on_checkpoint"] && current.checkpoint != old.checkpoint) return true;
    if (settings["split_on_killed_final_boss"] && current.killed_final_boss > old.killed_final_boss) return true;
    return false;
}

// Zero-Clause BSD (0BSD)
// 
// Copyright (c) 2021-2022, Phillip Trudeau-Tavara
// All rights reserved.
// 
// Permission to use, copy, modify, and/or distribute this software
// for any purpose with or without fee is hereby granted.
// 
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
// WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
// THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
// CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
// LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
// NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
// WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
