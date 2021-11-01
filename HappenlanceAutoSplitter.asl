; Happenlance AutoSplitter v1.01e
; Works for Happenlance v1.01e and into the future (until I break it).
; You can try to write one for the older chances but, best of luck tbh.
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
    if (settings["split_on_checkpoint"] && current.checkpoint != 0xffff && current.checkpoint != old.checkpoint) return true;
    if (settings["split_on_killed_final_boss"] && current.killed_final_boss > old.killed_final_boss) return true;
    return false;
}
