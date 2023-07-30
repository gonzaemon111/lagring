json.checklists do
  json.array! @checklists, partial: 'checklist', as: :checklist
end
