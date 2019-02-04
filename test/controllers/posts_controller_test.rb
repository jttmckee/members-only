require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jason)
  end
  test "should get new if logged in" do
    post login_path params:{user:{email:@user.email, password:'password',
      remember_me:'0'}}
    get new_post_url
    assert_response :success
  end

  test "redirects new to root if logged out" do
    get new_post_url
    assert_redirected_to root_url
  end


  test "should create new post if logged in" do
    post login_path params:{user:{email:@user.email, password:'password',
      remember_me:'0'}}
    assert_difference 'Post.count', 1 do
      post posts_url params:{post:{title:"Hello World",
        body:"Really helloooo!"}}
    end
  end

  test "should not create new post if not logged in" do
    assert_difference 'Post.count', 0 do
      post posts_url params:{post:{title:"Hello World",
        body:"Really helloooo!"}}
    end
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

end
