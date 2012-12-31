require 'spec_helper'

describe Aka do

  before do
    @aka = Aka.new(display_name:'Happy Cat', email:'happycat@example.com',
                   password:'cat', password_confirmation:'cat')
    @aka.subdomain = 'happycat'
  end

  subject { @aka }
  it { should respond_to(:subdomain) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:profile_links) }
  it { should be_valid }

  describe "when password doesn't match confirmation" do
    before { @aka.password_confirmation = 'nope' }
    it { should_not be_valid }
  end

  describe "without a subdomain" do
    before { @aka.subdomain = nil }
    it { should be_invalid }
    it "should not be saved" do
      expect { @aka.save! }.to raise_error
    end
  end

  describe "duplicate" do
    before {
      @aka.save
      @dup = Aka.new(display_name:'Another happy cat', email:'anotherhappycat@example.com',
                     password:'cat', password_confirmation:'cat')
      @dup.subdomain = 'happycat'
    }
    subject { @dup }
    it { should be_invalid }
    it "should not be saved" do
      expect { @dup.save! }.to raise_error
    end
  end

  describe "with illegal characters in subdomain" do
    before { @aka.subdomain = 'hello world!' }
    it { should be_invalid }
  end

  describe "with a forced IDNA" do
    before { @aka.subdomain = 'xn--smland-jua' }
    it { should be_invalid }
  end

  describe "profile links" do
    before {
      @link = @aka.profile_links.build(href:'http://happycat.example.com',title:'Home Page')
    }
    it { should be_valid }
    it "should be creatable" do
      expect { @aka.save! }.to_not raise_error
    end
    describe "with missing title" do
      before { @link.title = nil }
      it { should be_invalid }
    end
    describe "with missing href" do
      before { @link.href = nil }
      it { should be_invalid }
    end
    describe "With invalid href" do
      before { @link.href = 'javascript:alert("OH YEAH")' }
      it { should be_invalid }
    end
  end

end
