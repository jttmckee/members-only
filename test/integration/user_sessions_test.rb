require 'test_helper'

class UserSessionsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:jason)

  end

  test "logging out when not logged in redirects to home page with no flash" do
    delete logout_path
    assert_redirected_to root_path
    assert flash.empty?
  end

  test "logging in a user successfully" do
    get root_path
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", login_path
    get login_path
    assert_template 'sessions/new'
    post login_path params:{user:{email:@user.email, password:'password',
      remember_me:'0'}}
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", login_path, count:0
    assert_equal @user.id, session[:id]
    assert_nil flash[:warning]
    assert_not_empty flash[:notice]
    assert_nil cookies[:user_id]
    assert_nil cookies[:remember_token]
    assert_nil @user.remember_digest
  end

  test "logging in with a bad password fails" do
    post login_path params:{user:{email:@user.email, password:'bad password'}}
    assert_redirected_to login_path
    follow_redirect!
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", login_path
    assert_nil session[:id]
    assert_not_empty flash[:warning]
    assert_nil flash[:notice]
  end

  test "logging in with a bad email fails" do
    post login_path params:{user:{email:'foo@foo.com', password:'password'}}
    assert_redirected_to login_path
    follow_redirect!
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", login_path
    assert_nil session[:id]
    assert_not_empty flash[:warning]
    assert_nil flash[:notice]

  end

  test "logging in and out with remember tokens" do
    post login_path params:{user:{email:@user.email, password:'password',
      remember_me: '1'}}
    @user.reload
    assert_redirected_to root_url
    follow_redirect!
    assert_not_nil cookies[:remember_token]
    assert_not_nil  @user.remember_digest
    assert_not_nil cookies[:user_id]
    assert_not_nil @user.id
    #Close browser
    session[:id] = nil
    #Reopen
    get root_url
    assert_not_nil session[:id]
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", login_path, count:0
    #Logout
    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", login_path
    assert_nil cookies[:id]

  end

end
