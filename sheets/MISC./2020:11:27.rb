
set :bpm, 120


live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

set_mixer_control! hpf: 0, hpf_slide: 0
set_mixer_control! lpf: 130
set_mixer_control! amp: 1, amp_slide: 8

set :chord_progression, [:d2]

with_fx :reverb, room: 0.5 do
  live_loop :bass_2, sync: :metro do
    with_fx :eq, amp: 0.5, amp_slide: 64 do
      ##| stop
      use_bpm get[:bpm]
      cp = get[:chord_progression].tick(:cp)
      n1 = [0,0,0,7, 2,4,0,1, 5,2,0,1, 5,4,0,2].tick(:note)
      n2 = [0,0,0,7, 2,4,0,1, 5,2,0,1, 5,4,0,2].shuffle.tick(:note2)
      notes = scale(cp, :minor)[n1]
      notes_2 = scale(cp, :minor)[n2]
      ##| notes = scale(cp, :minor).shuffle.tick(:note）
      
      with_fx :compressor, amp: 1.5 do
        with_fx :hpf, cutoff: 0, cutoff_slide: 32 do
          synth :tb303,
            note: notes_2,
            release: 0.1,
            amp: choose([0, 2]),
            ##| amp: 0,
            res: (range 0, 0.9, step: 0.05).shuffle.tick(:res),
            ##| res: 0.9,
            ##| cutoff: (range 60, 130, stsep: 0.05).mirror.tick(:cutoff),
            pan: (range -1, 1, step: 0.25).mirror.tick(:pan),
            wave: 0
          if one_in(5)
            with_fx :reverb, room: 0.1 do
              synth :fm,
                note: notes + 12 ,
                attack: 0,
                release: 0.1,
                amp: 0.5,
                ##| depth: (range 0, 3, step: 0.1).shuffle.tick,
                depth: 0
              ##| divisor: (range 0, 1, step: 0.01).shuffle.tick
            end
          end
          sleep 0.25
        end
      end
    end
  end
end

live_loop :ground, sync: :metro do
  use_bpm get[:bpm]
  stop
  cp = get[:chord_progression].tick(:cp)
  n = [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0].tick(:n)
  notes = scale(cp, :minor)[n]
  
  synth :tb303,
    note: notes,
    amp: 0.5,
    res: 0.1,
    wave: 0,
    release: 0.1
  sleep 0.25
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
  sample :elec_cymbal, rate: 0.5, sustain: 0.025, release: 0.025, amp: 1.5, cutoff: 80 if spread(32,128).rotate(n_rand_1).tick(:t1)
  sleep 0.25
end
##| end