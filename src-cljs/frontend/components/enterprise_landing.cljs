(ns frontend.components.enterprise-landing
  (:require [frontend.components.common :as common]
            [frontend.utils :as utils :include-macros true]
            [om.core :as om])
  (:require-macros [frontend.utils :refer [html]]))

(def enterprise-logo
  [:figure.enterprise-logo
   [:img {:src (utils/cdn-path "/img/outer/enterprise/logo-circleci.svg")}]
   [:figcaption "CircleCI Enterprise"]])

(defn home [app owner]
  (reify
    om/IDisplayName (display-name [_] "Homepage")
    om/IRender
    (render [_]
      (html
       [:div.enterprise-landing
        [:div.jumbotron
         common/language-background-jumbotron
         [:section.container
          [:div.row
           [:article.hero-title.center-block
            [:div.text-center enterprise-logo]
            [:h1.text-center "Welcome to CircleCI"]
            [:h3.text-center "Click below to get started."]]]]]
        [:div.row.text-center
         (common/sign-up-cta owner "enterprise-landing")]]))))
