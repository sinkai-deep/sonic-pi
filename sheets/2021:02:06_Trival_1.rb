bpm = 150

live_loop :metro do
  use_bpm bpm
  sleep 4
end

with_fx :reverb, room: 0.5 do
  live_loop :base, sync: :metro do
    use_bpm bpm
    use_random_seed dice(9999)
    tick(:base)
    num = rrand_i(1, 16)
    num2 = rrand_i(4, 16)
    num3 = rrand_i(4, 16)
    
    ##| stop
    16.times do
      note = scale(:e2, :chinese).shuffle.look(:base)
      if spread(num, num2).rotate(num3).look(:base)
        synth :pluck,
          attack: 0,
          amp: 0.3,
          release: [0.25, 0.5].choose,
          note: note
      end
      sleep [0.25, 0.5].choose
    end
    
  end
end

with_fx :reverb, room: 0.8 do
  live_loop :base_2, sync: :metro do
    use_bpm bpm
    stop
    tick(:b2)
    
    n = [0, 0].look(:b2)
    notes = scale(:e3, :minor)[n]
    with_fx :slicer, phase: [0.25, 0.5, 0.75].choose do
      synth :prophet,
        note: notes,
        amp: 0.1,
        release: 16
    end
    sleep 16
  end
end

with_fx :reverb, room: 0.3 do
  live_loop :bd, sync: :metro do
    use_bpm bpm
    tick
    num = dice(32)
    
    with_fx :compressor do
      with_fx :lpf, cutoff: 90 do
        with_fx :eq, mid: 0.5, low: 1, high: 0.4 do
          sample :bd_zum, amp: 1, cutoff: 90, rate: 1, start: 0.05 if spread(1,4).look
          sample :tabla_dhec, amp: 1, release: 0.5 if spread(3,8).look
          sample :tabla_ghe3, sustain: 0.25, release: 0.25 if spread(1,16).rotate(1).look
          sample :tabla_ke1, amp: 0.01 if spread(6,16).rotate(5).look
          sample :tabla_na, amp: 0.1 if spread(4,16).rotate(num).look
          sample :tabla_na_o,amp: 0.1 if spread(3,32).rotate(num + 1).look
          sample :tabla_tas1, amp: 0.5 if spread(2,16).rotate(3).look
          sample :tabla_tun1, amp: 0.1 if spread(1,32).rotate(9).look
          sample :tabla_te_ne, amp: 0.7 if spread(8,32).rotate(0).look
        end
      end
    end
    sleep 0.25
  end
end