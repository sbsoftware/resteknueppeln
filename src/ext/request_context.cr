class Crumble::Server::RequestContext
  def self.init_session_store
    FileSessionStore.new("tmp/sessions")
  end

  def session_cookie_max_age
    365.days
  end
end
