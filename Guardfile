guard 'cucumber',
      all_after_pass: true,
      all_on_start: true,
      keep_failed: true do

  clearing = true
  watch(%r{^features/.+\.feature$})
  watch(%r{^lib/.+$}) { "features" }
  watch(%r{^features/step_definitions/.+$}) { "features" }
  watch(%r{^features/support/.+$}) { "features" }
end
