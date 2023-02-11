defmodule Covid19Web.ErrorJSONTest do
  use Covid19Web.ConnCase, async: true

  test "renders 404" do
    assert Covid19Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Covid19Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
