
##| set :key, scale(:c2, :minor)


live_loop :test do
  use_bpm 110
  sc = [:c2, :f2, :g2].look
  32.times do
    n = [0,0,1,2].tick
    key = scale(sc, :minor)
    ##| notes = get[:key][n]
    notes = key[n]
    synth :dsaw ,note: notes, release: 0.15, res: 0, wave: 0
    sleep 0.25
  end
end

live_loop :perc do
  ##| stop
  use_bpm 110
  num = rrand_i(16,32)
  sample "/Exsammples/samples/Super Saiyan Drum Kit/Kick/Kick (2).wav",
    amp: 1 if spread(1,4).tick
  sample "/Exsammples/samples/Super Saiyan Drum Kit/Hat/Hat (2).wav",
    amp: 0.7, cutoff: 100 if spread(1,4).rotate(2).look
  sleep 0.25
end