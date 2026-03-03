Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https, :unsafe_inline
    policy.style_src   :self, :https, :unsafe_inline
    policy.frame_src   :self, "https://www.youtube.com", "https://www.youtube-nocookie.com", "https://youtu.be", "https://player.vimeo.com"
  end
end
