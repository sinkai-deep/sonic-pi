
set :bpm, 115


live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

set_mixer_control! hpf: 0, hpf_slide: 0
set_mixer_control! lpf: 130
set_mixer_control! amp: 1, amp_slide: 0

set :chord_progression, [:a2]

with_fx :reverb, room: 0.5 do
  live_loop :bass_2, sync: :metro do
    with_fx :eq, amp: 0.5, amp_slide: 64 do
      ##| stop
      use_bpm get[:bpm]
      cp = get[:chord_progression].tick(:cp)
      n1 = [1,0,0,7, 2,4,0,1, 1,0,0,1, 5,4,0,2].tick(:note)
      n2 = [7,0,4,7, 2,4,0,1, 5,2,0,1, 5,4,0,7].shuffle.tick(:note2)
      notes = scale(cp, :minor)[n1]
      notes_2 = scale(cp, :minor)[n2]
      ##| notes = scale(cp, :minor).shuffle.tick(:note）
      
      with_fx :compressor, amp: 1.5 do
        with_fx :hpf, cutoff: 0, cutoff_slide: 32 do
          synth :tb303,
            note: notes - 12,
            release: 0.25,
            amp: choose([1, 1]),
            ##| amp: 0,
            res: (range 0, 0.9, step: 0.05).mirror.tick(:res),
            ##| res: 0.9,
            cutoff: (range 60, 130, stsep: 0.05).mirror.tick(:cutoff),
            pan: (range -1, 1, step: 0.25).mirror.tick(:pan),
            wave: 1
          if one_in(5)
            synth :fm,
              note: notes_2 + 24,
              attack: 0,
              release: 0.25,
              amp: 1,
              depth: (range 0, 1, step: 0.01).mirror.tick,
              ##| depth: 0,
              divisor: (range 0, 2, step: 0.01).shuffle.tick
          end
          sleep 0.25
        end
      end
    end
  end
end


live_loop :ground, sync: :metro do
  ##| with_fx :ixi_techno, phase: 2 do
  use_bpm get[:bpm]
  ##| stop
  cp = get[:chord_progression].tick(:cp)
  n = [0,0,0,7, 0,0,0,1, 0,0,0,7, 0,0,0,1].tick(:n)
  notes = scale(cp, :minor)[n]
  
  synth :tb303,
    wave: 1,
    note: notes,
    cutoff: 0.3,
    amp: 0.7,
    release: 0.12
  sleep 0.25
end
##| end

with_fx :reverb, room: 1 do
  live_loop :chords, sync: :metro do
    ##| stop
    use_bpm get[:bpm]
    cp = get[:chord_progression].tick
    notes = chord(cp, :m)
    notes_2 = chord(:g2, :m7)
    
    sleep 0.5
    synth :fm,
      amp: 1,
      note: notes_2 + 12,
      depth: 1,
      release: 0.5
    sleep 0.5
    
    synth :fm,
      amp: 1.2,
      note: notes + 24,
      depth: 1,
      release: 0.7
    sleep 7
    
  end
end

with_fx :reverb, room: 0.5 do
  live_loop :chords_2, sync: :metro do
    stop
    use_bpm get[:bpm]
    cp = get[:chord_progression].tick
    notes = chord(cp, :m)
    
    sleep 1
    synth :fm,
      amp: 0.8,
      note: notes + 12,
      depth: 0,
      release: 1
    sleep 4
    
  end
end


live_loop :drum, sync: :metro do
  use_bpm get[:bpm]
  ##| stop
  num = rrand_i(64, 128)
  
  n_rand_1 = rrand_i(0, 4)
  ##| with_fx :ixi_techno, phase: 32 do
  sample :bd_ada, cutoff: 130, amp: 2 if spread(1,4).tick
  sample :elec_filt_snare,amp: 1,sustain: 0.05, cutoff: 90 if spread(1,4).rotate(2).look
  sample :elec_cymbal, amp: 0.1, sustain: 0.02 if spread(4,4).rotate(2).look
  ##| sample :elec_cymbal, rate: 0.5, sustain: 0.025, release: 0.025, amp: 1.5, cutoff: 80 if spread(32,128).rotate(n_rand_1).tick(:t1)
  sleep 0.25
end
##| end