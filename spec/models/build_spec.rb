require 'spec_helper'

describe Build do

  let(:vcs_url) { "https://github.com/arohner/circle-dummy-project" }
  let!(:project) { Project.unsafe_create :vcs_url => vcs_url }
  let(:build) { Build.unsafe_create(:vcs_url => vcs_url,
                                    :committer_email => "user@test.com",
                                    :branch => "remotes/origin/mybranch",
                                    :vcs_revision => "abcdef01234566789",
                                    :failed => true,
                                    :build_num => 5,
                                    :subject => "I fixed a thingy in the whatsit",
                                    :project => project
                                    )}
  let!(:user) { User.create(:email => "user@test.com", :name => "Test user") }


  it "should support committer_handle" do
    build.committer_handle.should == "user"
  end

  it "should have an unknwon branch" do
    build.branch = nil
    build.branch_in_words.should == "unknown"
  end

  it "should have a HEAD branch" do
    build.branch = "HEAD"
    build.branch_in_words.should == "HEAD"
  end

  it "shouldn't list the remote part of the branch" do
    build.branch = "remotes/origin/some_branch"
    build.branch_in_words.should == "some_branch"
  end

  it "should have the right instant message format" do
    build.as_html_instant_message.should == "Failed: <a href='http://circlehost:3000/gh/arohner/circle-dummy-project/5'>arohner/circle-dummy-project #5</a>:" +
      "<br> - latest revision: " +
      "<a href='https://github.com/arohner/circle-dummy-project/commit/abcdef01234566789'>" +
      "<img src='http://circlehost:3000/assets/octocat-tiny.png'>" +
      "abcdef012" +
      "</a> " +
      "(mybranch)" +
      "<br> - author: user@test.com" +
      "<br> - log: I fixed a thingy in the whatsit"
    # Note that this also tests that there is no "triggered by" at the bottom
  end

  it "shouldn't mention the github trigger" do
    build.why = "github"
    build.as_html_instant_message.should_not =~ /Circle web UI/
  end

  it "should mention who started a build in an IM" do
    build.why = "trigger"
    build.user = user
    build.as_html_instant_message.should =~ /<br> - triggered by Test user from the Circle web UI/
  end

  it "should have the right email subject format" do
    build.as_email_subject.should == "Failed: arohner/circle-dummy-project #5 by user: I fixed a thingy in the whatsit"
  end


end
