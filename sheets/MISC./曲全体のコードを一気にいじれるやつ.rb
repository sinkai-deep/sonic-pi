bpm = 120
chord_name = ([:a2, :e2, :d2, :e2])
chord_tone = :minor7

live_loop :metro do
  use_bpm bpm
  sleep 4
end

with_fx :reverb, room: 0.5 do
  live_loop :bass_1, sync: :metro  do
    ##| stop
    use_bpm bpm
    chord_name_b1 = chord_name.tick
    notes_b1 = chord(chord_name_b1, chord_tone,num_octaves: 1)
    puts notes_b1
    s = :beep
    32.times do
      player_b1 = synth s,
        note: choose(notes_b1), release: 0.1, amp: 0.3
      sleep 0.25
    end
  end
end

with_fx :reverb, room: 0.3 do
  live_loop :bass_2, sync: :metro  do
    ##| stop
    use_bpm bpm
    chord_name_b1 = chord_name.tick
    amount_invert = ([2,3,4,5,6,7]).look
    notes_b1 = chord(chord_name_b1, chord_tone, num_octaves: 4, invert: amount_invert)
    s = :beep
    32.times do
      if one_in(1)
        player_b1 = synth s,
          note: choose(notes_b1), release: 0.1, amp: 0.3, hard: 0.2
        sleep 0.25
      else
        sleep 0.25
      end
    end
  end
end



live_loop :beats, sync: :metro do
  ##| stop
  use_bpm bpm
  kick = "/Exsammples/samples/Quarantine Drum Kit/kick/"
  sample kick,5, rate: 1.5 if spread(1,4).tick
  sleep 0.25
end

