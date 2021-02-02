##|------------ACID BASS-------------##

set :bpm, 130

live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

set_mixer_control! hpf: 0, hpf_slide: 2
set_mixer_control! amp: 1, amp_slide: 16

set :chord_progression, [:e1]

with_fx :reverb, room: 0.1 do
  live_loop :bass, sync: :metro do
    ##| stop
    
    use_bpm get[:bpm]
    cp = get[:chord_progression].tick(:cp)
    n = [2,5,0,1 ,3,5,7,0 ,2,5,0,1 ,7,1,0,1].tick(:note)
    ##| n = [0,2,0,1 ,1,4,1,1 ,0,4,1,5 ,1,2,2,0].tick(:note)
    notes = scale(cp, :minor)[n]
    ##| notes = scale(cp, :minor).shuffle.tick(:note)
    
    with_fx :compressor, amp: 1 do
      with_fx :hpf, cutoff: 0, cutoff_slide: 2 do
        if one_in(1)
          synth :tb303,
            note: notes,
            release: 0.1,
            amp: 1,
            res: (range 0, 0.2, step: 0.01).mirror.tick(:res),
            ##| res: 0.9,
            wave: 1,
            cutoff: (range 80, 120, step: 1).mirror.tick(:cutoff)
        else
          sleep 0.25
        end
        sleep 0.25
      end
    end
  end
end

with_fx :reverb, room: 1 do
  live_loop :main , sync: :metro do
    ##| stop
    use_bpm get[:bpm]
    cp = get[:chord_progression].tick(:cp)
    n = [2,5,0,1 ,3,5,7,0 ,2,5,0,1 ,7,1,0,1].tick(:note)
    ##| n = [1,2,1,1 ,1,7,1,1 ,0,3,1,1 ,1,1,2,1].shuffle.tick(:note)
    notes = scale(cp, :minor)[n]
    ##| notes = scale(cp, :minor).shuffle.tick(:note)
    
    with_fx :compressor, amp: 1, amp_slide: 64 do
      if one_in(2)
        synth :fm,
          note: notes + 48,
          release: 0.5,
          depth: 1,
          divisor: 1
      else
        sleep 1
      end
      sleep 1
    end
  end
end


live_loop :ambi, sync: :metro do
  ##| stop
  use_bpm get[:bpm]
  
  notes = chord(:e3, 'minor')
  synth :dark_ambience,
    note: notes,
    amp: 2,
    attack: 0.5,
    release: 16,
    cutoff: 90
  sleep 4
end


live_loop :drum, sync: :metro do
  use_bpm get[:bpm]
  ##| stop
  num = rrand_i(25, 48)
  clap = "/Exsammples/samples/Quarantine Drum Kit/clap"
  with_fx :compressor, amp: 0.7 do
    ##| with_fx :bpf, centre: 110, res: 0.9 do
    sample "/Exsammples/samples/Quarantine Drum Kit/kick/",
      4, rate: 1, amp: 10, rate: 0.1, beat_stretch: 1.5 if spread(1,4).tick
    
    sample "/Exsammples/samples/Quarantine Drum Kit/hihat/hihat (3).wav",
      cutoff: 120 if spread(1,4).rotate(2).look
    
    with_fx :lpf, cutoff: 45 do
      sample "/Exsammples/samples/Quarantine Drum Kit/snare/snare (7).wav",
        amp: 10 if spread(num, 64).look
    end
    with_fx :lpf, cutoff: 100 do
      sample clap, 5, amp: 0.8 if spread(num, 64).look
    end
    sample clap, 0,
      amp: 2 if spread(1,8).look
    sample clap, 1,
      amp: 1 if spread(1,16).rotate(15).look
    sample clap, 9,
      amp: 1, cutoff: 90 if spread(2,16).rotate(13).look
    sleep 0.25
  end
end
