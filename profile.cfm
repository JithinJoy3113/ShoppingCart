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
                <span class = "ordersSpan py-3"><a href="" class="text-decoration-none profileSideNav">MY ORDERS</a></span>
                <div class = "accountSttingsDiv">
                    <span class="accountSetting">ACCOUNT SETTINGS</span>
                    <div class="accountLinksDiv d-flex flex-column">
                        <button class="personalBtn border-0 d-flex align-items-left" value= "" onclick="">Personal informaion</button>
                        <button class="personalBtn border-0 d-flex align-items-left" value= "" onclick="">Manage Address</button>
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
                            <input type="text" class = "form-control profileInput" value="#session.userMail#" name="profileEmail" id="profileEmail" disabled>
                            <input type="text" class = "ms-3 form-control profileInput" value="#session.phone#" name="profilePhone" id="profilePhone" disabled>
                        </div>
                    </div>
                    <button type = "button" name = "profileSav" class = "d-none addCategory mt-4 mx-auto" id="profileSave" value="#session.userId#" onClick="saveProfile(this)">Save</button>
                </div>
            </form>
            <div class = "personalInformationDiv d-flex flex-column pt-3 pb-4 pe-3" id = "manageAddressDiv">
                <span class = "personalInformationHead pb-3">Manage Address<button type="button" value="" class = "ms-2 profileEditBtn fw-bold" onclick = "">Edit</button></span>
                <span class = "addressAddSpan pb-3">
                    <button type="button" value="" class = "addAddressBtn border-0 d-flex align-items-center" onclick = "">
                        <img src="Assets/Images/plus.png" alt="" width="18" height="18" class = "me-2"> ADD NEW ADDRESS
                    </button>
                </span>
                <div class = "addressListDiv">
                    <div class = "addressDiv d-flex flex-column">
                        <span class="addressNameSpan fw-bold">Jithin Joy
                            <span class="ms-2 addressPhoneSpan">8943403113</span>
                        </span>
                        <span class="addressSpan">
                            Mariya Bhavan, Kulathupuzha
                        </span>
                    </div>
                </div>
                <button type = "button" name = "profileSave" class = "addCategory mt-4 mx-auto" id="profileSave" onclick="">Save</button>
            </div>
        </div>
    </div>
</cfoutput>