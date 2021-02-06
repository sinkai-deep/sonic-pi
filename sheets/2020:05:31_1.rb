bpm = 100

live_loop :metro do
  use_bpm bpm
  sleep 4
end

set_mixer_control! amp: 1, amp_slide: 8
set_mixer_control! lpf: 150, lpf_slide: 8

use_random_seed 0

live_loop :player_1, sync: :metro do
  ##| stop
  use_bpm bpm
  chord_name_1 = ([:a3, :e3, :d3, :e3]).tick
  chord_tone = ([:minor, :minor]).look
  notes_1 = chord(chord_name_1, chord_tone)
  s = :piano
  2.times do
    with_fx :reverb, room: 1, mix: 0.5 do
      player_1 = synth s, note: notes_1, vel: 0.2, hard: 0.3
    end
    sleep 4
  end
end

live_loop :bass_1, sync: :metro do
  ##| stop
  use_bpm bpm
  chord_name_b1 = ([:a2, :e2, :d2, :e2 ]).tick
  chord_tone = ([:minor, :minor]).look
  notes_b1 = chord(chord_name_b1, chord_tone)
  s = :beep
  16.times do
    with_fx :reverb, room: 1 do
      with_fx :echo, phase: 0.25 do
        if one_in(1)
          player_b1 = synth s,
            note: choose(notes_b1), release: 0.25
        else
          sleep 0.5
        end
      end
      sleep 0.5
    end
  end
end

live_loop :bass_2, sync: :metro do
  ##| stop
  use_bpm bpm
  chord_name_b2 = ([:a3, :e3, :d3, :e3]).tick
  chord_tone = ([:minor, :minor]).look
  notes_b2 = chord(chord_name_b2, chord_tone)
  s = :chipbass
  16.times do
    with_fx :reverb, room: 1, mix: 0.8 do
      if one_in(2)
        player_b2 = synth s,
          note: choose(notes_b2), release: 0.1, amp: 0.7, amp_slide: 16
      else
        sleep 0.5
      end
    end
    sleep 0.5
  end
end


live_loop :player_4, sync: :metro do
  ##| stop
  use_bpm bpm
  with_fx :compressor, amp: 0.5 do
    chord_name_4 = ([:a5, :e5, :d5, :e5]).tick
    chord_tone = ([:minor, :minor]).look
    notes_4 = chord(chord_name_4, chord_tone)
    s = :piano
    8.times do
      with_fx :reverb, room: 1 do
        if one_in(6)
          player_4 = synth s,
            note: choose(notes_4), release: 0.25,hard: 0.2
        else
          sleep 1
        end
      end
      sleep 1
    end
  end
end

live_loop :player_5, sync: :metro do
  ##| stop
  use_bpm bpm
  chord_name_5 = ([:a4, :e4, :d5, :e4]).tick
  chord_tone = ([:minor, :minor7]).look
  notes_5 = chord(chord_name_5, chord_tone)
  with_fx :reverb, room: 1, amp: 0.5 do
    s = :dark_ambience
    player_5 = synth s,
      note: choose(notes_5), release: 7, attack: 1
    sleep 8
  end
end


live_loop :ambi_1 do
  ##| stop
  use_bpm 100
  with_fx :eq ,amp: 0.5 do
    underwater =  "/Exsammples/samples/370754__ztitchez__drone-space-wind-scifi.wav"
    sample underwater ,rate: -0.5
    sleep sample_duration underwater
  end
end


live_loop :beats, sync: :metro do
  ##| stop
  use_bpm bpm
  with_fx :reverb, room: 1, amp: 3 do
    with_fx :echo, phase: 0.25 do
      kick = "/Exsammples/samples/Quarantine Drum Kit/kick/"
      sample kick,9 if spread(1,32).tick
      sleep 0.25
    end
  end
end
