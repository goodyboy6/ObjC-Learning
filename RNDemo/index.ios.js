'use strict';

import React, { Component } from 'React'
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    ScrollView,
    TouchableOpacity,
    Image
} from 'react-native';

class DetailView extends React.Component {
    render(){
        return (
                <View>
                <Text> RN Demo </Text>
                </View>
                );
    }
}

module.exports = DetailView;
AppRegistry.registerComponent('DetailView', () => DetailView);
