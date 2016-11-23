json.revision @sync_data.revision
json.entities do
  json.INSERT @sync_data.entities['INSERT'] do |model|
    json.set! model.class.to_s, model.as_json.map{|k,v| [k.camelize(:lower), v]}.to_h.to_json
  end
  json.UPDATE @sync_data.entities['UPDATE'] do |model|
    json.set! model.class.to_s, model.as_json.map{|k,v| [k.camelize(:lower), v]}.to_h.to_json
  end
  json.REMOVE @sync_data.entities['REMOVE'] do |model|
    json.set! model.class.to_s, model.as_json.map{|k,v| [k.camelize(:lower), v]}.to_h.to_json
  end
end
