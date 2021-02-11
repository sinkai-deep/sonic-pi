bpm = 130

with_fx :compressor, threshold: 1  do
  
  live_loop :metro do
    use_bpm bpm
    sleep 4
  end
  
  set_mixer_control! hpf: 0, hpf_slide: 4
  set_mixer_control! lpf: 130, lpf_slide: 0
  set_mixer_control! amp: 1, amp_slide: 2
  
  with_fx :reverb, room: 1 do
    live_loop :ground, sync: :metro do
      with_fx :compressor, threshold: 0.8 do
        ##| with_fx :slicer, phase: 0.75 do
        use_bpm bpm
        ##| stop
        2.times do
          tick
          n = scale(:e5, :minor)[0]
          notes = n + (ring 0, 2, 2, 0).look
          notes2 = n + (ring 3, 5, 5, 7).look
          
          with_fx :eq, high: 0  do
            synth :sine,
              note: notes,
              attack: 0,
              amp: 0.7,
              release: 0.25
            with_fx :eq, high: 1  do
              synth :sine,
                note: notes2,
                attack: 0,
                amp: 0.5,
                release: 0.25
            end
            sleep 1.5
          end
        end
        sleep 5
        ##| sleep 5 if one_in(3)
        ##| end
        ##| stop
        ##| end
      end
    end
  end
  
  with_fx :compressor, threshold: 1 do
    live_loop :bass, sync: :metro do
      use_bpm bpm
      ##| stop
      tick
      n = [:e2].look
      16.times do
        with_fx :hpf, cutoff: 20 do
          synth :fm,
            note: n,
            depth: 1,
            attack: 0,
            amp: 0.9,
            release: 0.5 if spread(8,8).rotate(2).look
        end
        sleep 0.5
      end
    end
  end
  
  with_fx :reverb, room: 1, mix: 0.5 do
    live_loop :chords, sync: :metro do
      ##| stop
      use_bpm bpm
      tick
      n = [0].look
      notes = chord(:e4, :m)
      num = 16
      ##| if one_in(1)
      with_fx :lpf, cutoff: 100 do
        with_fx :slicer, phase: [0.75].choose do
          ##| with_fx :ixi_techno, phase: dice(16) do
          synth :fm,
            amp: 0.6,
            depth: 0,
            attack: 0.1,
            note: notes,
            release: num,
            sustain: num*0.3
          ##| end
        end
      end
      
      if one_in(1)
        sample :guit_em9, beat_stretch: num,
          rate: [-12,-8, -4, 4, 8, 12].choose, amp: 0.7
      end
      sleep num
      ##| stop
    end
  end
  
  with_fx :compressor, threshold: 1 do
    live_loop :bd, sync: :metro do
      ##| stop
      use_bpm bpm
      tick
      with_fx :bpf, centre: 50, res: 0.7 do
        with_fx :eq, amp: 2, low: 1, mid: 1, high: 0.4 do
          sample :bd_tek, amp: 2,
            rate: 1,
            attack: 0,
            beat_stretch: 0.5,
            rate: 1
        end
      end
      ##| stop
      sleep 1
    end
  end
  
  with_fx :reverb, room: 0.5 do
    with_fx :compressor, threshold: 0.5 do
      live_loop :pc, sync: :metro do
        ##| stop
        use_bpm bpm
        tick
        with_fx :eq, amp: 0.7,low: 0.3, high: 0, mid: 1 do
          sample :drum_snare_soft,
            amp: 1,
            beat_stretch: 0.1,
            rate: 0.1, release: 0.1,
            sustain: 0.1 if spread(1 ,8).rotate(4).look
          
          sample :drum_snare_soft,
            amp: 1,
            beat_stretch: 0.2,
            rate: 0.2, release: 0.1,
            sustain: 0.1 if spread(1 ,16).rotate(7).look
        end
        sleep 0.25
      end
    end
  end
end







