require_relative '../spec_helper.rb'

module Jekyll::PaginateV2::AutoPages
  describe Utils do

    describe "expand_placeholders" do
      it "should return string unmodified when no placeholders are present" do
        Utils.expand_placeholders("hello world", {}).must_equal "hello world"
        Utils.expand_placeholders("hello world", { ":foo" => "bar" }).must_equal "hello world"
      end

      it "should replace placeholders in the string" do
        Utils.expand_placeholders("xyz:foo:bar:foo", { ":foo" => "abc", ":bar" => "def" }).must_equal "xyzabcdefabc"
        Utils.expand_placeholders("xyz:foo:foobar:foo", { ":foo" => "abc", ":foobar" => "def" }).must_equal "xyzabcdefabc"
      end

      it "should not replace placeholders inside replacements" do
        Utils.expand_placeholders(":foo:bar:foo", { ":foo" => ":bar", ":bar" => ":foo" }).must_equal ":bar:foo:bar"
      end
    end
  end
end
