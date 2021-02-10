

set :chord_progression, [:d2, :e2, :a2, :e2]
set :chord_tone, :minor

bpm = 120
set_mixer_control! amp: 1, amp_slide: 8

live_loop :metro do
  use_bpm bpm
  sleep 4
end

with_fx :reverb, room: 0.5 do
  live_loop :bass_1, sync: :metro  do
    ##| stop
    use_bpm bpm
    chord_b1 = get[:chord_progression].tick
    notes_b1 = chord(chord_b1, get[:chord_tone],num_octaves: 2)
    puts notes_b1
    s = :dpulse
    16.times do
      with_fx :echo, phase: 0.25 do
        player_b1 = synth s,
          note: choose(notes_b1), release: 0.1, amp: 0.3
        sleep 0.5
      end
    end
  end
end

with_fx :reverb, room: 1 do
  live_loop :bass_2, sync: :metro  do
    ##| stop
    use_bpm bpm
    chord_b2 = get[:chord_progression].tick
    amount_invert = ([2,3,4,5,6,7]).look
    notes_b1 = chord(chord_b2, get[:chord_tone], num_octaves: 4, invert: amount_invert)
    s = :beep
    16.times do
      if one_in(3)
        player_b1 = synth s,
          note: choose(notes_b1), release: 0.5, amp: 0.3
        sleep 0.5
      else
        sleep 0.5
      end
    end
  end
end



live_loop :beats, sync: :metro do
  ##| stop
  use_bpm bpm
  kick = "/Exsammples/samples/Quarantine Drum Kit/kick/"
  sample kick,5, rate: 0.5 if spread(1,4).tick
  sleep 0.25
end

