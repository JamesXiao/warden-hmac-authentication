
context "an HMAC object" do

  setup do
    HMAC.new("md5")
  end

  context "> calculating the canonical query string" do
    
    setup do
      topic.canonical_querystring({
        "foo" => "bar",
        "baz" => "foo bar"
      })
    end
    
    asserts("querystring"){topic}.equals("baz=foo+bar&foo=bar")
    
  end

  context "> generating the signature of a url" do
    
    setup do
      topic.generate_signature("http://example.org?foo=bar&baz=foobar", "secret")
    end
    
    asserts("signature") {topic}.equals("4e8488fcfdea30d400861973ba03e079")
    asserts("query parameter order does not matter") { topic == HMAC.new("md5").generate_signature("http://example.org?baz=foobar&foo=bar", "secret")}
    asserts("token parameter is not taken into consideration") { topic == HMAC.new("md5").generate_signature("http://example.org?foo=bar&baz=foobar&token=4e8488fcfdea30d400861973ba03e079", "secret") }
  end

  asserts("checking a url_signature") { topic.check_signature("http://example.org?foo=bar&baz=foobar&token=4e8488fcfdea30d400861973ba03e079", "secret") }
  denies("checking an invalid url_signature") { topic.check_signature("http://example.org?foo=bar&baz=foobar&token=888488fcfdea30d400861973ba03e079", "secret") }
  
  asserts("signing a url") { topic.sign_url("http://example.org?foo=bar&token=888488fcfdea30d400861973ba03e079", "secret", "token", {"baz" => "foobar"}) }.equals("http://example.org?baz=foobar&foo=bar&token=4e8488fcfdea30d400861973ba03e079")
  
end