//
//  ProfileView.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-16.
//

import SwiftUI

struct ProfileView: View {
  
  let horizontalPadding = 16
  
    var body: some View {
      NavigationView {
        VStack(alignment: .leading, spacing: 0) {
          makeProfileImageView()
            .padding(.bottom, 15)
          makeProfileInfoVStack()
            .padding(.bottom, 20)
          Button(action: {
            print("Edit profile")
           }) {
            Text("Edit Profile")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(ShortRoundedOutlineButtonStyle())
          Spacer()
        }
        .navigationViewStyle(.stack)
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .toolbar(content: {
          makeToolBar()
        })
//        .navigationBarTitleDisplayMode(.inline)
      }
      .navigationViewStyle(.stack)
    }
  
  private func makeProfileInfoVStack() -> some View {
    VStack(alignment: .leading)
    {
      makeInfoHStack(imageName: "map-marker", text: "Location N/A", spacing: 10)
      makeInfoHStack(imageName: "phone", text: "+1 604-222-2222", spacing: 3)
    }
  }
  
  private func makeInfoHStack(imageName: String, text: String, spacing: CGFloat) -> some View {
    HStack(spacing: spacing) {
      Image(imageName)
      Text(text)
        .font(Font.lightInter(size: 14.0))
        .foregroundColor(Color.utilityBody)
    }
  }
  
  private func makeProfileImageView() -> some View {
    HStack(spacing: 16) {
      Button {
        print("add profile image")
      } label: {
        Image("profile-add")
      }
      VStack(alignment: .leading, spacing: 2) {
  
        Text("Monica Dominique")
          .foregroundColor(Color.utilityBody)
          .font(Font.boldInter(size: 18))
        HStack {
          Text("Brokerage")
            .foregroundColor(Color.utilityBody)
            .font(Font.lightInter(size: 14))
          Text("Free")
            .font(Font.mediumInter(size: 12))
            .foregroundColor(Color.buttonSecondaryFG)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
              Capsule()
                .fill(Color.utilityGray50)
            )
            .overlay(
              Capsule()
                .stroke(Color.progressBackground, lineWidth: 1)
            )
        }
      }
      Spacer()
    }
  }
  
  @ToolbarContentBuilder
  private func makeToolBar() -> some ToolbarContent {
    ToolbarItemGroup(placement: .navigationBarLeading) {
      Button {
        print("open up left menu")
      } label: {
        Image("menu")
      }
    }
    ToolbarItemGroup(placement: .navigationBarTrailing) {
      Button {
        print("Get premium")
      } label: {
        HStack(spacing: 8) {
          Image("rocket")
            .renderingMode(.template)
          Text("Get Premium")
            .font(Font.boldInter(size: 12))
        }
        .foregroundColor(Color.primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.secondary)
        .cornerRadius(8)
      }
    }
  }
}

#Preview {
    ProfileView()
}
