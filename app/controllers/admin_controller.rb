class AdminController < ApplicationController
  def index
    @user = User.find(session[:user_id])
  end

  def backup

    str = Person.to_rb
    str += Family.to_rb
    str += Credit.to_rb
    str += Skill.to_rb
    str += User.to_rb
    str += Applicant.to_rb

    str = "<pre># encoding: utf-8\n#{str}\n</pre>"

    respond_to do |format|
      format.html {render text: str }
    end
  end

  def header
    @people = Person.active.order('first_name')
  end

  def update
    images = params[:images]
    path = Rails.root.join('public')

    cmd_str = <<COMMAND
convert \\
  -page +0+0  #{path}/header_layers/base.png \\
  -page +0+0  \\( #{path}/cast_images/#{images['7']}.jpg \\
    -alpha set -virtual-pixel transparent \\
    +distort Perspective '0,0 375,31 0,300 386,83 261,0 430,23 261,300 432,77' \\) \\
  -page +0+0  #{path}/header_layers/frame1.png \\
  -page +0+0  \\( #{path}/cast_images/#{images['6']}.jpg \\
    -alpha set -virtual-pixel transparent \\
    +distort Perspective '0,0 417,16 0,300 417,91 261,0 471,21 261,300 471,85' \\) \\
  -page +0+0  #{path}/header_layers/frame2.png \\
  -page +0+0  \\( #{path}/cast_images/#{images['5']}.jpg \\
    -alpha set -virtual-pixel transparent \\
    +distort Perspective '0,0 463,9 0,300 462,106 261,0 532,17 261,300 532,99' \\) \\
  -page +0+0  #{path}/header_layers/frame3.png \\
  -page +0+0  \\( #{path}/cast_images/#{images['4']}.jpg \\
    -alpha set -virtual-pixel transparent \\
    +distort Perspective '0,0 507,75 0,300 558,151 261,0 564,19 261,300 630,119' \\) \\
  -page +0+0  #{path}/header_layers/frame4.png \\
  -page +0+0  \\( #{path}/cast_images/#{images['3']}.jpg \\
    -alpha set -virtual-pixel transparent \\
    +distort Perspective '0,0 565,35 0,300 618,152 261,0 651,11 261,300 693,105' \\) \\
  -page +0+0  #{path}/header_layers/frame5.png \\
  -page +0+0  \\( #{path}/cast_images/#{images['2']}.jpg \\
    -alpha set -virtual-pixel transparent \\
    +distort Perspective '0,0 688,15 0,300 660,155 261,0 791,52 261,300 765,172' \\) \\
  -page +0+0  #{path}/header_layers/frame6.png \\
  -page +0+0  \\( #{path}/cast_images/#{images['1']}.jpg \\
    -alpha set -virtual-pixel transparent \\
    +distort Perspective '0,0 745,101 0,300 835,189 261,0 810,9 261,300 936,140' \\) \\
  -background None -flatten #{path}/images/header.png
COMMAND

    `#{cmd_str}`

    respond_to do |format|
      format.html { redirect_to root_url,
                    notice: "Website header has been updateded" }
    end

  end

end
