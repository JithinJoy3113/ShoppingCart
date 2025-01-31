<cfoutput>
    <div class = "profileBodyDiv d-flex">
        <div class = "profileLeftDiv d-flex flex-column">
            <div class = "profileNameDiv d-flex">
                <div class = "profileImg">
                    <img src="Assets/Images/profile.png" alt="" width="50" height="50">
                </div>
                <div class = "profileName d-flex flex-column px-2 py-2">
                    <span class="hello">Hello,</span>
                    <span class="fw-bold" id="profileFullNameSpan">#session.firstName# #session.lastName#</span>
                </div>
            </div>
            <div class = "myOrdersDiv d-flex flex-column">
                <span class = "ordersSpan py-3"><a href="orderHistory.cfm" class="text-decoration-none profileSideNav">MY ORDERS</a></span>
                <div class = "accountSttingsDiv">
                    <span class="accountSetting">ACCOUNT SETTINGS</span>
                    <div class="accountLinksDiv d-flex flex-column">
                        <button class="personalBtn border-0 d-flex align-items-left" value= "" onclick="openPersonalInformation()">Personal informaion</button>
                        <button class="personalBtn border-0 d-flex align-items-left" value= "" onclick="openManageAddress()">Manage Address</button>
                    </div>
                </div>
                <span class = "ordersSpan profileSideNav py-3"><a href="cart.cfm" class="profileSideNav text-decoration-none">MY CART</a></span>
            </div>
        </div>
        <div class = "profileRightDiv">
            <form action="" method = "post" id="profileForm">
                <div class = "personalInformationDiv d-flex flex-column pt-3 pb-4 pe-3" id = "personalInformationDiv">
                    <span class = "personalInformationHead pb-3">Personal Informaion <button type="button" value="" class = "fw-bold ms-2 profileEditBtn" id="profileEditBtn" onclick = "editProfile(this)">Edit</button></span>
                    <div class = "profileInputDiv d-flex flex-column">
                        <span class="profileLabel">Name</span>
                        <div class = "nameInputDiv d-flex pt-2">
                            <input type="text" class = "form-control profileInput" value="#session.firstName#" name="profileFirstName" id="profileFirstName" disabled>
                            <input type="text" class = "ms-3 form-control profileInput" value="#session.lastName#" name="profileLastName" id="profileLastName" disabled>
                        </div>
                        <span class="mt-4 profileLabel">Email/Phone</span>
                        <div class = "emailInputDiv d-flex pt-2">
                            <input type="text" class = "form-control profileInput" data-value="#session.userMail#" value="#session.userMail#" name="profileEmail" id="profileEmail" disabled>
                            <input type="text" class = "ms-3 form-control profileInput" data-value="#session.phone#" value="#session.phone#" name="profilePhone" id="profilePhone" disabled>
                        </div>
                    </div>
                    <span class = "fw-bold removeSpan" id = "profileError"></span>
                    <button type = "button" name = "profileSav" class = "d-none addCategory mt-4 mx-auto" id="profileSave" value="#session.userId#" onClick="saveProfile(this)">Save</button>
                </div>
            </form>
            <div class = "personalInformationDiv d-none flex-column pt-3 pb-4 pe-3" id = "manageAddressDiv">
                <span class = "addressAddSpan pb-3">
                    <button type="button" value="" class = "addAddressBtn border-0 d-flex align-items-center" onclick = "openAddressModal()">
                        <img src="Assets/Images/plus.png" alt="" width="18" height="18" class = "me-2"> ADD NEW ADDRESS
                    </button>
                </span>
                <div class = "addressListDiv" id="addressListDiv">
                    <cfset local.address = application.obj.fetchAddress()>
                        <cfloop array="#local.address#" item="item">
                           <div class="addressMainDiv d-flex justify-content-between" id="address#item.addressID#">
                                <div class = "addressDiv d-flex flex-column">
                                    <span class="addressNameSpan fw-bold">#item.firstName# #item.lastName#
                                        <span class="ms-2 addressPhoneSpan">#item.phone#</span>
                                    </span>
                                    <span class="addressSpan">
                                        #item.addressOne#, #item.addressTwo#, #item.city#, #item.state#, #item.pincode#
                                    </span>
                                </div>
                               <div class = "addressEditBtnDiv d-flex align-items-center" data-value = "#item.addressID#">
                                    <img src="Assets/Images/dots.png" alt="" class = "addressEditImg" data-value = "#item.addressID#" width="20" height="20">
                                </div>
                                <div class="addressEditDiv py-3" id="#item.addressID#" data-value = "#item.addressID#">
                                    <!-- <button type="button">Edit</button> -->
                                    <button type="button bt-2" value = "#item.addressID#" class="addressDltbtn" onClick = "deleteProfileAddress(this)">Delete</button>
                                </div>
                            </div>
                        </cfloop>
                </div>
                <button type = "button" name = "profileSave" class = "addCategory mt-4 mx-auto d-none" id="profileAddressSave" onclick="">Save</button>
            </div>
            <div class = "addressModal pb-3 fw-bold" id="addressModal">
                <form action="" method="post" id="addressForm">
                    <span class="addressHead px-2 py-3">Add New Address</span>
                    <div class="addressNameDiv d-flex py-3">
                        <input type="text" placeholder="FirstName" class="form-control" name="firstName">
                        <input type="text" placeholder="LastName" class="form-control ms-2" name="lastName">
                    </div>
                    <div class="addressLineDiv d-flex py-3">
                        <textarea name="addressOne" id="lineOne" placeholder="Address Line 1" class="form-control"></textarea>
                        <textarea name="addressTwo" id="lineTwo" placeholder="Address Line 2 " class="form-control ms-2"></textarea>
                    </div>
                    <div class="stateDiv d-flex py-3">
                        <input type="text" class="form-control" placeholder="City" name="city">
                        <input type="text" class="form-control  ms-2" placeholder="State" name="state">
                    </div>
                    <div class="pinDiv d-flex py-3">
                        <input type="text" class="form-control" placeholder="Pincode" name="pincode">
                        <input type="text" class="form-control ms-2" placeholder="Phone" name="phone">
                    </div>
                    <div class="d-flex justify-content-center py-3">
                        <button type="button" value="" class="addAddressClose" onclick="addAddressCloseBtn()">Cancel</button>
                        <button type="button" value="" class="addCategory" onclick="addAddressBtn()">Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</cfoutput>

